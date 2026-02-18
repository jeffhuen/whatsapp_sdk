defmodule WhatsApp.ApplicationBusinessConnections.ConnectedClientBusinessesService do
  @moduledoc """
  APIs for managing application connected client business relationships
  """

  @doc """
  Get Connected Client Businesses

  Retrieve a list of client businesses connected to the specified application.


  **Use Cases:**
  - Monitor application-business client relationships
  - Verify connected business configurations
  - Retrieve business connection status and details
  - Manage client business access and permissions


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Business connection data can be cached for moderate periods, but status information may change.
  Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, name, verification_status, business_status).
  Available fields: id, name, verification_status, business_status, created_time, updated_time

    - `limit` (integer, optional) - Maximum number of connected client businesses to return per page. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use this to get the next page of results.

    - `before` (string, optional) - Cursor for pagination. Use this to get the previous page of results.

  """
  @spec get_connected_client_businesses(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.ConnectedClientBusinesses.t()}
          | {:ok, WhatsApp.Resources.ConnectedClientBusinesses.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_connected_client_businesses(client, application_id, opts \\ []) do
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
           "/#{client.api_version}/#{application_id}/connected_client_businesses",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ConnectedClientBusinesses)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ConnectedClientBusinesses),
         resp}

      error ->
        error
    end
  end
end
