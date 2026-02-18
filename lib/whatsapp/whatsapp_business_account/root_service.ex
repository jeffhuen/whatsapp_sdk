defmodule WhatsApp.WhatsappBusinessAccount.RootService do
  @moduledoc """
  APIs for managing WhatsApp Business Account details and configuration
  """

  @doc """
  Get WhatsApp Business Account Details

  Retrieve comprehensive details about a WhatsApp Business Account, including its
  configuration, status, and settings.

  **Use Cases:**
  - Retrieve WhatsApp Business Account configuration and details
  - Monitor account status and verification state
  - Check account ownership and business information
  - Validate account state before messaging operations

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Caching:**
  Account details can be cached for moderate periods, but verification status may change.
  Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, name). Available fields: id, name, timezone_id,
  message_template_namespace, account_review_status, business_verification_status,
  country, ownership_type, primary_business_location

  """
  @spec get_whats_app_business_account_details(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def get_whats_app_business_account_details(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    WhatsApp.Client.request(
      client,
      :get,
      "/#{client.api_version}/#{waba_id}",
      [params: query_params] ++ opts
    )
  end

  @doc """
  Update WhatsApp Business Account

  Update configuration and settings for a WhatsApp Business Account.

  **Use Cases:**
  - Update WhatsApp Business Account name and configuration
  - Modify account settings and preferences
  - Update business information and verification details

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  ## Examples

  ### Update account name

      %{"name" => "Updated Business Name"}

  ### Update timezone

      %{"timezone_id" => "2"}
  """
  @spec update_whats_app_business_account(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.UpdateWhatsAppBusinessAccount.t()}
          | {:ok, WhatsApp.Resources.UpdateWhatsAppBusinessAccount.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def update_whats_app_business_account(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UpdateWhatsAppBusinessAccount)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.UpdateWhatsAppBusinessAccount
         ), resp}

      error ->
        error
    end
  end
end
