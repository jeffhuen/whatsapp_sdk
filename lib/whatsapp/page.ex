defmodule WhatsApp.Page do
  @moduledoc """
  Paginated API response with cursor-based navigation.

  Supports eager fetching (list one page) and lazy streaming
  (process all pages via `Stream`).

  ## WhatsApp Pagination Format

  The WhatsApp Cloud API uses cursor-based pagination:

      %{
        "data" => [...],
        "paging" => %{
          "cursors" => %{"before" => "QVFIUl...", "after" => "QVFIUk..."},
          "next" => "https://graph.facebook.com/v23.0/.../message_templates?after=QVFIUk...",
          "previous" => "https://graph.facebook.com/v23.0/.../message_templates?before=QVFIUl..."
        }
      }

  ## Usage

      # Parse a response into a Page
      page = WhatsApp.Page.from_response(response_body, &deserialize/1)

      # Check for more pages
      WhatsApp.Page.has_next?(page)

      # Stream all items across all pages lazily
      page
      |> WhatsApp.Page.stream(client)
      |> Stream.filter(&active?/1)
      |> Enum.to_list()
  """

  @type t :: %__MODULE__{
          data: list(),
          cursors: %{before: String.t() | nil, after: String.t() | nil},
          next_url: String.t() | nil,
          previous_url: String.t() | nil
        }

  defstruct data: [],
            cursors: %{before: nil, after: nil},
            next_url: nil,
            previous_url: nil

  @doc """
  Parse a paginated API response into a Page struct.

  `response_map` is the decoded JSON map with `"data"` and `"paging"` keys.
  `deserialize_fn` is a function that transforms each data item. Pass `nil`
  to keep raw maps.

  ## Examples

      iex> response = %{"data" => [%{"id" => "1"}], "paging" => %{"cursors" => %{"after" => "abc"}}}
      iex> page = WhatsApp.Page.from_response(response, nil)
      iex> page.data
      [%{"id" => "1"}]

  """
  @spec from_response(map(), (map() -> any()) | nil) :: t()
  def from_response(response_map, deserialize_fn) do
    raw_data = response_map["data"] || []
    paging = response_map["paging"] || %{}
    cursors = paging["cursors"] || %{}

    data =
      if deserialize_fn do
        Enum.map(raw_data, deserialize_fn)
      else
        raw_data
      end

    %__MODULE__{
      data: data,
      cursors: %{
        before: cursors["before"],
        after: cursors["after"]
      },
      next_url: paging["next"],
      previous_url: paging["previous"]
    }
  end

  @doc """
  Returns `true` if the page has a next page URL.

  ## Examples

      iex> WhatsApp.Page.has_next?(%WhatsApp.Page{next_url: "https://..."})
      true

      iex> WhatsApp.Page.has_next?(%WhatsApp.Page{next_url: nil})
      false

  """
  @spec has_next?(t()) :: boolean()
  def has_next?(%__MODULE__{next_url: url}), do: url != nil

  @doc """
  Returns `true` if the page has a previous page URL.

  ## Examples

      iex> WhatsApp.Page.has_previous?(%WhatsApp.Page{previous_url: "https://..."})
      true

      iex> WhatsApp.Page.has_previous?(%WhatsApp.Page{previous_url: nil})
      false

  """
  @spec has_previous?(t()) :: boolean()
  def has_previous?(%__MODULE__{previous_url: url}), do: url != nil

  @doc """
  Create a lazy stream that auto-pages through all items.

  Uses `Stream.unfold/2` to yield individual items from the current page,
  then automatically fetches the next page when data is exhausted.

  The stream stops when there are no more pages or on fetch error.

  ## Options

    * `:deserialize_fn` - Function to apply to items from fetched pages.
      Items from the initial page are yielded as-is (already deserialized
      by `from_response/2`).
    * `:fetch_fn` - Custom fetch function `(client, url) -> {:ok, map()} | {:error, term()}`.
      Defaults to `WhatsApp.Client.request_url/2`. Useful for testing.

  ## Examples

      # Stream all templates across all pages
      page
      |> WhatsApp.Page.stream(client, deserialize_fn: &deserialize/1)
      |> Enum.to_list()

      # Take only the first 50 items (lazy — fetches only needed pages)
      page
      |> WhatsApp.Page.stream(client)
      |> Enum.take(50)

  """
  @spec stream(t(), WhatsApp.Client.t() | nil, keyword()) :: Enumerable.t()
  def stream(%__MODULE__{} = page, client, opts \\ []) do
    deserialize_fn = Keyword.get(opts, :deserialize_fn)
    fetch_fn = Keyword.get(opts, :fetch_fn, &default_fetch/2)

    Stream.unfold({page.data, page.next_url, client, deserialize_fn, fetch_fn}, &unfold_step/1)
  end

  # Stream.unfold step function.
  # State: {remaining_items, next_url, client, deserialize_fn, fetch_fn}

  # Yield next item from current page data.
  defp unfold_step({[item | rest], next_url, client, deserialize_fn, fetch_fn}) do
    {item, {rest, next_url, client, deserialize_fn, fetch_fn}}
  end

  # Current page data exhausted and there is a next page — fetch it.
  defp unfold_step({[], next_url, client, deserialize_fn, fetch_fn})
       when is_binary(next_url) do
    case fetch_fn.(client, next_url) do
      {:ok, response_body} ->
        next_page = from_response(response_body, deserialize_fn)
        unfold_step({next_page.data, next_page.next_url, client, deserialize_fn, fetch_fn})

      {:error, _reason} ->
        # Stop the stream on error, don't crash
        nil
    end
  end

  # No more items and no next page — halt the stream.
  defp unfold_step({[], nil, _client, _deserialize_fn, _fetch_fn}) do
    nil
  end

  # Default fetch function using WhatsApp.Client.request_url/2.
  defp default_fetch(client, url) do
    WhatsApp.Client.request_url(client, url)
  end
end
