defmodule WhatsApp.CallPermissions.CallPermissionsService do
  @moduledoc """
  Use the **`/{Phone-Number-ID}/call_permissions`** endpoint to check whether you have permission to call a specific WhatsApp user and understand what calling-related actions are available.

  ## Prerequisites

  *   [User Access Token](https://developers.facebook.com/docs/facebook-login/access-tokens#usertokens) with **`whatsapp_business_messaging`** permission
  *   `phone-number-id` for your registered WhatsApp Business Account
  *   WhatsApp Cloud API Calling must be enabled for your phone number

  ## Permission Status Types

  - **granted**: You have active permission to call this user
  - **pending**: A permission request has been sent but not yet approved by the user
  - **denied**: The user has denied call permissions for your business
  - **expired**: Previous permission has expired and needs to be renewed

  ## Available Actions

  - **start_call**: Initiate a new call to this user (available when permission is granted)
  - **send_call_permission_request**: Send a permission request to this user (available when permission is denied or expired)

  ## Rate Limiting

  This endpoint has specific rate limits to prevent abuse. Exceeding the rate limit will result in error code 4 with subcode 2390008.

  ## Error Handling

  - **403 Forbidden**: Calling is not enabled for your phone number - **429 Too Many Requests**: Rate limit exceeded for permission checks - **400 Bad Request**: Missing or invalid `user_wa_id` parameter

  """

  @doc """
  Check Call Permissions

  Check whether you have permission to call a WhatsApp user and what actions are available. This endpoint returns the current permission status for calling a specific user, along with available actions and their limits.

  **Permission Status:**
  - `granted`: You have active permission to call this user - `pending`: A permission request has been sent but not yet approved - `denied`: The user has denied call permissions - `expired`: Previous permission has expired

  **Available Actions:**
  - `start_call`: Initiate a new call to this user - `send_call_permission_request`: Send a permission request to this user

  **Error Handling:**
  This endpoint may return various error codes including rate limiting errors if too many permission checks are made within a short period.


  ## Parameters

    - `user_wa_id` (string, **required**) - The WhatsApp ID of the user you want to check call permissions for
  """
  @spec check_call_permissions(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def check_call_permissions(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [{:user_wa_id, Keyword.get(opts, :user_wa_id)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    WhatsApp.Client.request(
      client,
      :get,
      "/#{client.api_version}/#{phone_number_id}/call_permissions",
      [params: query_params] ++ opts
    )
  end
end
