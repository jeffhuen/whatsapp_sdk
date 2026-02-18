defmodule WhatsApp.MultiPartnerSolutions.SolutionsService do
  @moduledoc """
  APIs for managing Multi-Partner Solutions that enable collaborative WhatsApp Business
  messaging between solution owners and partner applications.

  """

  @doc """
  List Multi-Partner Solutions for WABA

  Retrieve a paginated list of Multi-Partner Solutions associated with the specified
  WhatsApp Business Account. This endpoint supports field selection and cursor-based
  pagination for efficient data retrieval.


  **Use Cases:**
  - Discover available Multi-Partner Solutions for business onboarding
  - Monitor solution status and availability across your WABA
  - Retrieve solution ownership and permission details
  - Filter solutions by specific fields or status requirements


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Solution listings can be cached for short periods, but status information may change
  frequently during transitions. Implement appropriate cache invalidation strategies.


  **Pagination:**
  This endpoint supports cursor-based pagination using `limit`, `after`, and `before`
  parameters. Use the `paging` object in responses to navigate through result sets.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (name, status, status_for_pending_request).
  Available fields: id, name, status, status_for_pending_request, owner_app, owner_permissions

    - `limit` (integer, optional) - Maximum number of solutions to return per page. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Returns solutions after this cursor position.
  Use the cursor from the previous response's `paging.cursors.after` field.

    - `before` (string, optional) - Cursor for pagination. Returns solutions before this cursor position.
  Use the cursor from the previous response's `paging.cursors.before` field.

  """
  @spec list_waba_solutions(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def list_waba_solutions(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{waba_id}/solutions",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.WhatsAppBusinessSolution)
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.WhatsAppBusinessSolution)
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `list_waba_solutions/2` that auto-pages through all results."
  @spec stream_waba_solutions(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_waba_solutions(client, opts \\ []) do
    case list_waba_solutions(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn:
            &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.WhatsAppBusinessSolution)
        )

      error ->
        error
    end
  end
end
