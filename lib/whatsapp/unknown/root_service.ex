defmodule WhatsApp.Unknown.RootService do
  @moduledoc false

  @doc """
  Delete Group

  Delete the group and remove all participants, including the business

  ## Parameters

    - `group_id` (string, **required**) - Group ID
  """
  @spec delete_group(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.DeleteGroup.t()}
          | {:ok, WhatsApp.Resources.DeleteGroup.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def delete_group(client, group_id, opts \\ []) do
    case WhatsApp.Client.request(client, :delete, "/#{client.api_version}/#{group_id}", opts) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteGroup)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteGroup), resp}

      error ->
        error
    end
  end

  @doc """
  Get Group Info

  Retrieve metadata about a single group

  ## Parameters

    - `group_id` (string, **required**) - Group ID
    - `fields` (string, optional) - Comma-separated list of fields to return
  """
  @spec get_group_info(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.GroupInfo.t()}
          | {:ok, WhatsApp.Resources.GroupInfo.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_group_info(client, group_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{group_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GroupInfo)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GroupInfo), resp}

      error ->
        error
    end
  end

  @doc """
  Update Group Settings

  Update the subject, description, and photo of a group

  ## Parameters

    - `group_id` (string, **required**) - Group ID
  """
  @spec update_group_settings(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def update_group_settings(client, group_id, params, opts \\ []) do
    WhatsApp.Client.request(
      client,
      :post,
      "/#{client.api_version}/#{group_id}",
      [json: params] ++ opts
    )
  end
end
