defmodule WhatsApp.MessageHistory.MessageHistoryService do
  @moduledoc """
  APIs for retrieving WhatsApp Business Account message history and delivery status information
  """

  @doc """
  Get WhatsApp Business Account Message History

  Retrieve paginated message history for a WhatsApp Business Account phone number,
  including delivery status events, timestamps, and webhook update information.


  **Use Cases:**
  - Track message delivery status and events
  - Monitor webhook delivery and update states
  - Retrieve historical message delivery information
  - Debug message delivery issues and webhook failures


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Message history data can be cached for moderate periods, but delivery status events
  may change frequently. Implement appropriate cache invalidation strategies.


  **Pagination:**
  This endpoint supports cursor-based pagination. Use the `after` and `before` cursors
  from the response to navigate through results.


  ## Parameters

    - `message_id` (string, optional) - Filter results by specific WhatsApp message ID (WAMID). When provided,
  only message history for this specific message will be returned.

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, message_id).
  Available fields: id, message_id, events{delivery_status,webhook_update_state,timestamp,application,webhook_uri,error_description}

    - `limit` (integer, optional) - Maximum number of message history entries to return per page.
  Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use this to get the next page of results.
  This value comes from the `paging.cursors.after` field in previous responses.

    - `before` (string, optional) - Cursor for pagination. Use this to get the previous page of results.
  This value comes from the `paging.cursors.before` field in previous responses.

  """
  @spec get_message_history(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_message_history(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [
        {:message_id, Keyword.get(opts, :message_id)},
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{phone_number_id}/message_history",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.WhatsAppMessageHistory)
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.WhatsAppMessageHistory)
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `get_message_history/2` that auto-pages through all results."
  @spec stream_message_history(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_message_history(client, opts \\ []) do
    case get_message_history(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn:
            &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.WhatsAppMessageHistory)
        )

      error ->
        error
    end
  end
end
