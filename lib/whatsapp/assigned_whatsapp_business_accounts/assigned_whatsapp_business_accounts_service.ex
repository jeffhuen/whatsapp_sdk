defmodule WhatsApp.AssignedWhatsappBusinessAccounts.AssignedWhatsappBusinessAccountsService do
  @moduledoc """
  APIs for managing assigned WhatsApp Business Accounts for users
  """

  @doc """
  Get Assigned WhatsApp Business Accounts

  Retrieve WhatsApp Business Accounts that have been assigned to a specific user.
  This endpoint provides information about account assignments, permissions, and
  current status corresponding to the GraphAssignedWhatsAppBusinessAccountsEdge node.


  **Use Cases:**
  - Retrieve all WhatsApp Business Accounts assigned to a user
  - Check user permissions for specific accounts
  - Monitor account assignment status and changes
  - Validate user access before performing business operations


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Assignment information can be cached for short periods, but permissions and status
  may change frequently. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, name, status).
  Available fields: id, name, status, assignment_date, permissions, business_id, phone_numbers

    - `limit` (integer, optional) - Maximum number of accounts to return per page. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use this to get the next page of results.

    - `before` (string, optional) - Cursor for pagination. Use this to get the previous page of results.

  """
  @spec get_assigned_whats_app_business_accounts(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.AssignedAccounts.t()}
          | {:ok, WhatsApp.Resources.AssignedAccounts.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_assigned_whats_app_business_accounts(client, user_id, opts \\ []) do
    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{user_id}/assigned_whatsapp_business_accounts",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.AssignedAccounts)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.AssignedAccounts), resp}

      error ->
        error
    end
  end
end
