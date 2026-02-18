defmodule WhatsApp.BlockUsers.BlockUsersService do
  @moduledoc false

  @doc """
  Block user(s)

  - Guide: [Block Users](https://developers.facebook.com/docs/business-messaging/whatsapp/block-users)
      
  - Endpoint reference: [POST WhatsApp Buiness Phone Number > block_users](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-account-to-number-current-status/block_users/#Creating)

  ## Examples

  ### Block user(s)

      %{
    "block_users" => [%{"user" => "+16505551234"}],
    "messaging_product" => "whatsapp"
  }
  """
  @spec block_user_s(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.BlockUsersData.t()}
          | {:ok, WhatsApp.Resources.BlockUsersData.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def block_user_s(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/block_users",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.BlockUsersData)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.BlockUsersData), resp}

      error ->
        error
    end
  end

  @doc """
  Get blocked users

  - Guide: [Block Users](https://developers.facebook.com/docs/business-messaging/whatsapp/block-users)
      
  - Endpoint reference: [GET WhatsApp Buiness Phone Number > block_users](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-account-to-number-current-status/block_users/#Reading)
  """
  @spec get_blocked_users(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_blocked_users(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{phone_number_id}/block_users",
           opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.BlockedUser)
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.BlockedUser)
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `get_blocked_users/2` that auto-pages through all results."
  @spec stream_blocked_users(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_blocked_users(client, opts \\ []) do
    case get_blocked_users(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn: &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.BlockedUser)
        )

      error ->
        error
    end
  end

  @doc """
  Unblock user(s)

  - Guide: [Block Users](https://developers.facebook.com/docs/business-messaging/whatsapp/block-users)
      
  - Endpoint reference: [DELETE WhatsApp Buiness Phone Number > block_users](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-account-to-number-current-status/block_users/#Deleting)

  ## Examples

  ### Unblock user(s)

      %{
    "block_users" => [%{"user" => "+16505551234"}],
    "messaging_product" => "whatsapp"
  }
  """
  @spec unblock_user_s(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.UnblockUsersData.t()}
          | {:ok, WhatsApp.Resources.UnblockUsersData.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def unblock_user_s(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :delete,
           "/#{client.api_version}/#{phone_number_id}/block_users",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UnblockUsersData)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UnblockUsersData), resp}

      error ->
        error
    end
  end
end
