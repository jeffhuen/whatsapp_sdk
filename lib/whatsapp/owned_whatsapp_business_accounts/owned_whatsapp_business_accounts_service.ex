defmodule WhatsApp.OwnedWhatsappBusinessAccounts.OwnedWhatsappBusinessAccountsService do
  @moduledoc """
  APIs for retrieving WhatsApp Business Accounts owned by a business
  """

  @doc """
  Get Owned WhatsApp Business Accounts

  Retrieve WhatsApp Business Accounts owned by the specified business. This endpoint
  provides comprehensive information about all WABAs owned by the business, including
  account details, configuration, and status information.

  **Use Cases:**
  - Retrieve all WhatsApp Business Accounts owned by a business
  - Filter accounts by business type
  - Find specific accounts by ID
  - Monitor business portfolio of WhatsApp Business Accounts
  - Manage account access and permissions across multiple WABAs

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Caching:**
  Account information can be cached for short periods, but status and configuration
  may change frequently. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `business_type` (array, optional) - Filter accounts by business type. Can specify multiple types as comma-separated values.
  Use this to filter between enterprise and small-medium business accounts.

    - `after` (string, optional) - Cursor for forward pagination. Use the cursor from the previous response
  to get the next page of results.

    - `first` (integer, optional) - Number of results to return in forward pagination. Maximum value is 100.
  Use with 'after' cursor for forward pagination.

    - `before` (string, optional) - Cursor for backward pagination. Use the cursor from the previous response
  to get the previous page of results.

    - `last` (integer, optional) - Number of results to return in backward pagination. Maximum value is 100.
  Use with 'before' cursor for backward pagination.

    - `find` (string, optional) - Find a specific WhatsApp Business Account by ID within the owned accounts.
  Use this to quickly locate a specific account.

  """
  @spec get_owned_whats_app_business_accounts(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessAccountsConnection.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessAccountsConnection.t(),
             WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_owned_whats_app_business_accounts(client, business_id, opts \\ []) do
    query_params =
      [
        {:business_type, Keyword.get(opts, :business_type)},
        {:after, Keyword.get(opts, :after)},
        {:first, Keyword.get(opts, :first)},
        {:before, Keyword.get(opts, :before)},
        {:last, Keyword.get(opts, :last)},
        {:find, Keyword.get(opts, :find)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{business_id}/owned_whatsapp_business_accounts",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessAccountsConnection
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessAccountsConnection
         ), resp}

      error ->
        error
    end
  end
end
