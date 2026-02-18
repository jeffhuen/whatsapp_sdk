defmodule WhatsApp.ClientWhatsappBusinessAccounts.ClientWhatsappBusinessAccountsService do
  @moduledoc """
  APIs for managing client WhatsApp Business Account relationships
  """

  @doc """
  Get Client WhatsApp Business Accounts

  Retrieve a list of WhatsApp Business Accounts that have been shared with the specified business.


  **Use Cases:**
  - Monitor shared WABA relationships and permissions
  - Verify WABA configuration and status information
  - Retrieve WABA details for business integrations
  - Manage multi-business WhatsApp messaging setups


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  WABA information can be cached for moderate periods, but status information may change
  frequently. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, name, currency, timezone_id).
  Available fields: id, name, account_review_status, purchase_order_number, audiences, ownership_type, subscribed_apps, business_verification_status, country, currency, timezone_id, on_behalf_of_business_info, schedules, is_enabled_for_insights, dcc_config, message_templates, phone_numbers

    - `business_type` (array, optional) - Filter results by WhatsApp Business Account type

    - `limit` (integer, optional) - Maximum number of WhatsApp Business Accounts to return per page. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use this to get the next page of results.

    - `before` (string, optional) - Cursor for pagination. Use this to get the previous page of results.

    - `find` (string, optional) - Find a specific WhatsApp Business Account by ID

  """
  @spec get_client_whats_app_business_accounts(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.ClientWhatsAppBusinessAccounts.t()}
          | {:ok, WhatsApp.Resources.ClientWhatsAppBusinessAccounts.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_client_whats_app_business_accounts(client, business_id, opts \\ []) do
    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:business_type, Keyword.get(opts, :business_type)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)},
        {:find, Keyword.get(opts, :find)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{business_id}/client_whatsapp_business_accounts",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.ClientWhatsAppBusinessAccounts
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.ClientWhatsAppBusinessAccounts
         ), resp}

      error ->
        error
    end
  end
end
