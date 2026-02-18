defmodule WhatsApp.PhoneNumberRegistration.RegisterService do
  @moduledoc """
  APIs for registering and managing WhatsApp Business phone numbers
  """

  @doc """
  Register WhatsApp Business Phone Number

  Register a WhatsApp Business phone number for messaging capabilities and enable
  two-step verification. This is a required step before sending messages through
  the WhatsApp Business Cloud API.


  **Registration Process:**
  1. Phone number must be in UNVERIFIED status
  2. Provide a 6-digit PIN for two-step verification
  3. Optionally provide backup data for account migration
  4. Registration activates messaging capabilities


  **Migration Support:**
  For migrating from on-premises WhatsApp Business API, include backup data
  with password and encrypted account information.


  **Rate Limiting:**
  Registration attempts are rate-limited to prevent abuse. Standard Graph API
  rate limits apply with additional restrictions for registration endpoints.


  **Security Requirements:**
  - Two-step verification is mandatory for all registered numbers
  - PIN must be securely stored and managed by the business
  - Registration enables webhook delivery and message sending capabilities


  ## Examples

  ### Registration with data localization settings

      %{
    "data_localization_region" => "AE",
    "messaging_product" => "whatsapp",
    "pin" => "123456"
  }

  ### Basic phone number registration

      %{"messaging_product" => "whatsapp", "pin" => "123456"}

  ### Account migration registration

      %{
    "backup" => %{
      "data" => "YOUR_BACKUP_DATA",
      "password" => "YOUR_BACKUP_PASSWORD"
    },
    "messaging_product" => "whatsapp",
    "pin" => "123456"
  }
  """
  @spec register_whats_app_business_phone_number(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessPhoneNumberRegistration.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessPhoneNumberRegistration.t(),
             WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def register_whats_app_business_phone_number(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/register",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessPhoneNumberRegistration
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessPhoneNumberRegistration
         ), resp}

      error ->
        error
    end
  end
end
