defmodule WhatsApp.MessageHistoryEvents.EventsService do
  @moduledoc """
  APIs for retrieving WhatsApp Business Message History Events and delivery status occurrences
  """

  @doc """
  Get WhatsApp Message History Events

  Retrieve paginated message delivery status events for a specific message history entry,
  including delivery status occurrences, timestamps, and application information.


  **Use Cases:**
  - Track detailed message delivery status events and transitions
  - Monitor delivery status occurrence timestamps
  - Retrieve application information for delivery events
  - Debug message delivery issues and status changes


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Message history events can be cached for short periods, but delivery status events
  may change frequently. Implement appropriate cache invalidation strategies.


  **Pagination:**
  This endpoint supports cursor-based pagination. Use the `after` and `before` cursors
  from the response to navigate through results.


  ## Parameters

    - `status_filter` (, optional) - Filter results by specific delivery status. When provided,
  only events with this delivery status will be returned.

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (cursor, node{id,delivery_status,occurrence_timestamp}).
  Available fields: cursor, node{id,delivery_status,error_description,occurrence_timestamp,status_timestamp,application}

    - `limit` (integer, optional) - Maximum number of message history events to return per page.
  Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use this to get the next page of results.
  This value comes from the `paging.cursors.after` field in previous responses.

    - `before` (string, optional) - Cursor for pagination. Use this to get the previous page of results.
  This value comes from the `paging.cursors.before` field in previous responses.

  """
  @spec get_message_history_events(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.MessageHistoryEvents.t()}
          | {:ok, WhatsApp.Resources.MessageHistoryEvents.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_message_history_events(client, message_history_id, opts \\ []) do
    query_params =
      [
        {:status_filter, Keyword.get(opts, :status_filter)},
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{message_history_id}/events",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.MessageHistoryEvents)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.MessageHistoryEvents),
         resp}

      error ->
        error
    end
  end
end
