defmodule WhatsApp.Flows.RootService do
  @moduledoc false

  @doc """
  Delete Flow

  Deletes the flow entirely. This action is not reversible. Only a DRAFT flow can be deleted.
  """
  @spec delete_flow(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.DeleteFlow.t()}
          | {:ok, WhatsApp.Resources.DeleteFlow.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def delete_flow(client, flow_id, opts \\ []) do
    case WhatsApp.Client.request(client, :delete, "/#{client.api_version}/#{flow_id}", opts) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteFlow)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteFlow), resp}

      error ->
        error
    end
  end

  @doc """
  Get Flow

  Can request specific fields by enabling the \`fields\` query param

  ## Parameters

    - `fields` (string, optional) - Return specific fields in the response
    - `date_format` (string, optional) - Returns date as unix timestamp in seconds
  """
  @spec get_flow(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.GetFlow.t()}
          | {:ok, WhatsApp.Resources.GetFlow.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_flow(client, flow_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}, {:date_format, Keyword.get(opts, :date_format)}]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{flow_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GetFlow)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GetFlow), resp}

      error ->
        error
    end
  end

  @doc """
  Update Flow Metadata

  Update Flow Metadata
  """
  @spec update_flow_metadata(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.UpdateFlowMetadata.t()}
          | {:ok, WhatsApp.Resources.UpdateFlowMetadata.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def update_flow_metadata(client, flow_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{flow_id}",
           [multipart: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UpdateFlowMetadata)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UpdateFlowMetadata),
         resp}

      error ->
        error
    end
  end
end
