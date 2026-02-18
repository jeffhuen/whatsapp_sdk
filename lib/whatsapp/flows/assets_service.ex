defmodule WhatsApp.Flows.AssetsService do
  @moduledoc false

  @doc """
  List Assets (Get Flow JSON URL)

  Returns all assets attached to the flow. Currently only FLOW_JSON asset is supported
  """
  @spec list_assets_get_flow_json_url(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.ListAssetsGetFlowJsonUrl.t()}
          | {:ok, WhatsApp.Resources.ListAssetsGetFlowJsonUrl.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def list_assets_get_flow_json_url(client, flow_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{flow_id}/assets",
           [multipart: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ListAssetsGetFlowJsonUrl)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ListAssetsGetFlowJsonUrl),
         resp}

      error ->
        error
    end
  end

  @doc """
  Update Flow JSON

  Used to upload a flow JSON file with the flow content. Refer to flow JSON documentation here [https://developers.facebook.com/docs/whatsapp/flows/reference/flowjson](https://developers.facebook.com/docs/whatsapp/flows/reference/flowjson)

  The file must be attached as from data. The response will include any validation errors in the JSON file
  """
  @spec update_flow_json(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.UpdateFlowJson.t()}
          | {:ok, WhatsApp.Resources.UpdateFlowJson.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def update_flow_json(client, flow_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{flow_id}/assets",
           [multipart: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UpdateFlowJson)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UpdateFlowJson), resp}

      error ->
        error
    end
  end
end
