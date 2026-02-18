defmodule WhatsApp.InviteLink.InviteLinkService do
  @moduledoc false

  @doc """
  Create Group Invite Link

  Create a new group invite link

  ## Parameters

    - `group_id` (string, **required**) - Group ID
  """
  @spec create_group_invite_link(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.CreateGroupInviteLink.t()}
          | {:ok, WhatsApp.Resources.CreateGroupInviteLink.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def create_group_invite_link(client, group_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{group_id}/invite_link",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.CreateGroupInviteLink)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.CreateGroupInviteLink),
         resp}

      error ->
        error
    end
  end

  @doc """
  Delete Group Invite Link

  Delete an existing group invite link

  ## Parameters

    - `group_id` (string, **required**) - Group ID
  """
  @spec delete_group_invite_link(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.DeleteGroupInviteLink.t()}
          | {:ok, WhatsApp.Resources.DeleteGroupInviteLink.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def delete_group_invite_link(client, group_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :delete,
           "/#{client.api_version}/#{group_id}/invite_link",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteGroupInviteLink)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.DeleteGroupInviteLink),
         resp}

      error ->
        error
    end
  end
end
