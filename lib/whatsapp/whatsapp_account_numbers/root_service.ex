defmodule WhatsApp.WhatsappAccountNumbers.RootService do
  @moduledoc """
  APIs for managing WhatsApp Account Number details and configuration
  """

  @doc """
  Get WhatsApp Account Number Details

  Retrieve comprehensive details about a WhatsApp Account Number, including its current status,
  verification information, quality rating, and configuration settings.

  **Use Cases:**
  - Monitor account number status and quality rating
  - Verify account number configuration before messaging operations
  - Check verification and approval status
  - Retrieve display name and business profile information

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Caching:**
  Account number details can be cached for short periods, but status information may change
  frequently. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, display_phone_number, status).
  Available fields: id, display_phone_number, verified_name, status, quality_rating,
  country_code, country_dial_code, code_verification_status, name_status,
  messaging_limit_tier, account_mode, certificate, is_official_business_account

  """
  @spec get_whats_app_account_number_details(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppAccountNumber.t()}
          | {:ok, WhatsApp.Resources.WhatsAppAccountNumber.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_whats_app_account_number_details(client, whatsapp_account_number_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{whatsapp_account_number_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppAccountNumber)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppAccountNumber),
         resp}

      error ->
        error
    end
  end
end
