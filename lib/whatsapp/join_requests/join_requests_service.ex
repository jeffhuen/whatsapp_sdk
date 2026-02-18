defmodule WhatsApp.JoinRequests.JoinRequestsService do
  @moduledoc false

  @doc """
  Approve Join Requests

  Approve one or more join requests

  ## Parameters

    - `group_id` (string, **required**) - Group ID
  """
  @spec approve_join_requests(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.ApproveJoinRequests.t()}
          | {:ok, WhatsApp.Resources.ApproveJoinRequests.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def approve_join_requests(client, group_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{group_id}/join_requests",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ApproveJoinRequests)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ApproveJoinRequests),
         resp}

      error ->
        error
    end
  end

  @doc """
  Get Join Requests

  Get a list of open join requests for a group

  ## Parameters

    - `group_id` (string, **required**) - Group ID
  """
  @spec get_join_requests(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.GetJoinRequests.t()}
          | {:ok, WhatsApp.Resources.GetJoinRequests.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_join_requests(client, group_id, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{group_id}/join_requests",
           opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GetJoinRequests)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.GetJoinRequests), resp}

      error ->
        error
    end
  end

  @doc """
  Reject Join Requests

  Reject one or more join requests

  ## Parameters

    - `group_id` (string, **required**) - Group ID
  """
  @spec reject_join_requests(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.RejectJoinRequests.t()}
          | {:ok, WhatsApp.Resources.RejectJoinRequests.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def reject_join_requests(client, group_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :delete,
           "/#{client.api_version}/#{group_id}/join_requests",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.RejectJoinRequests)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.RejectJoinRequests),
         resp}

      error ->
        error
    end
  end
end
