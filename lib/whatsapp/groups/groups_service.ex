defmodule WhatsApp.Groups.GroupsService do
  @moduledoc false

  @doc """
  Create Group

  Create a new group and get an invite link
  """
  @spec create_group(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.CreateGroup.t()}
          | {:ok, WhatsApp.Resources.CreateGroup.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def create_group(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/groups",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.CreateGroup)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.CreateGroup), resp}

      error ->
        error
    end
  end

  @doc """
  Get Active Groups

  Retrieve a list of active groups for a given business phone number

  ## Parameters

    - `limit` (integer, optional) - Number of groups to fetch in the request
    - `after` (string, optional) - Cursor that points to the end of a page of data
    - `before` (string, optional) - Cursor that points to the beginning of a page of data
  """
  @spec get_active_groups(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def get_active_groups(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    WhatsApp.Client.request(
      client,
      :get,
      "/#{client.api_version}/#{phone_number_id}/groups",
      [params: query_params] ++ opts
    )
  end
end
