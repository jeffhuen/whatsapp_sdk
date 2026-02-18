defmodule WhatsApp.Flows.PublishService do
  @moduledoc false

  @doc """
  Publish Flow

  Updates the status of the flow as "PUBLISHED". This action is not reversible. The flow and its assets become immutable once published. To update the flow, you must create a new flow and specify the previous flow id as the \`clone_flow_id\` parameter
  """
  @spec publish_flow(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.PublishFlow.t()}
          | {:ok, WhatsApp.Resources.PublishFlow.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def publish_flow(client, flow_id, opts \\ []) do
    case WhatsApp.Client.request(client, :post, "/#{client.api_version}/#{flow_id}/publish", opts) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.PublishFlow)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.PublishFlow), resp}

      error ->
        error
    end
  end
end
