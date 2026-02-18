defmodule WhatsApp.Flows.MigrateFlowsService do
  @moduledoc false

  @doc """
  Migrate Flows

  Creates a copy of existing flows from source WABA to destination WABA with the same names.
  """
  @spec migrate_flows(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.MigrateFlows.t()}
          | {:ok, WhatsApp.Resources.MigrateFlows.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def migrate_flows(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}/migrate_flows",
           [multipart: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.MigrateFlows)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.MigrateFlows), resp}

      error ->
        error
    end
  end
end
