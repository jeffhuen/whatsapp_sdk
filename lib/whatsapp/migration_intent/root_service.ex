defmodule WhatsApp.MigrationIntent.RootService do
  @moduledoc """
  APIs for retrieving WhatsApp Business Account migration intent details
  """

  @doc """
  Get Migration Intent Details

  Retrieve comprehensive details about a WhatsApp Business Account migration intent,
  including its current status and migration information.


  **Use Cases:**
  - Monitor migration intent lifecycle and status changes
  - Verify migration intent configuration and current state
  - Check migration progress and completion status
  - Retrieve migration intent details for business workflows


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Migration intent details can be cached for short periods, but status information may change
  frequently during migration processes. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, status).
  Available fields: id, status

  """
  @spec get_migration_intent_details(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessAccountMigrationIntent.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessAccountMigrationIntent.t(),
             WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_migration_intent_details(client, migration_intent_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{migration_intent_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessAccountMigrationIntent
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessAccountMigrationIntent
         ), resp}

      error ->
        error
    end
  end
end
