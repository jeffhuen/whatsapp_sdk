defmodule WhatsApp.Participants.ParticipantsService do
  @moduledoc false

  @doc """
  Add Group Participants

  Add participants to group

  ## Parameters

    - `group_id` (string, **required**) - Group ID
  """
  @spec add_group_participants(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def add_group_participants(client, group_id, params, opts \\ []) do
    WhatsApp.Client.request(
      client,
      :post,
      "/#{client.api_version}/#{group_id}/participants",
      [json: params] ++ opts
    )
  end

  @doc """
  Remove Group Participants

  Remove participants from group

  ## Parameters

    - `group_id` (string, **required**) - Group ID
  """
  @spec remove_group_participants(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def remove_group_participants(client, group_id, params, opts \\ []) do
    WhatsApp.Client.request(
      client,
      :delete,
      "/#{client.api_version}/#{group_id}/participants",
      [json: params] ++ opts
    )
  end
end
