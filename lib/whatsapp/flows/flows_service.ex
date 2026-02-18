defmodule WhatsApp.Flows.FlowsService do
  @moduledoc false

  @doc """
  Create Flow

  Creates a new flow. To clone an existing flow you can add the parameter

  `"clone_flow_id": "original-flow-id"`
  """
  @spec create_flow(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.CreateFlow.t()}
          | {:ok, WhatsApp.Resources.CreateFlow.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def create_flow(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}/flows",
           [multipart: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.CreateFlow)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.CreateFlow), resp}

      error ->
        error
    end
  end

  @doc """
  List Flows

  List Flows
  """
  @spec list_flows(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def list_flows(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)
    WhatsApp.Client.request(client, :get, "/#{client.api_version}/#{waba_id}/flows", opts)
  end
end
