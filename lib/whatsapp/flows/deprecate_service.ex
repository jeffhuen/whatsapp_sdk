defmodule WhatsApp.Flows.DeprecateService do
  @moduledoc false

  @doc """
  Deprecate Flow

  Updates the status of the flow as "DEPRECATED". This action is not reversible. Only a published flow can be deprecated to prevent sending or opening it.
  """
  @spec deprecate_flow(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.DeprecateFlow.t()}
          | {:ok, WhatsApp.Resources.DeprecateFlow.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def deprecate_flow(client, flow_id, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{flow_id}/deprecate",
           opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeprecateFlow)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeprecateFlow), resp}

      error ->
        error
    end
  end
end
