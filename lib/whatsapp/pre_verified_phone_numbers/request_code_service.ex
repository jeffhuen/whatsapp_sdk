defmodule WhatsApp.PreVerifiedPhoneNumbers.RequestCodeService do
  @moduledoc """
  APIs for managing pre-verified phone numbers for WhatsApp Business messaging
  """

  @doc """
  Request Verification Code for Pre-Verified Phone Number

  Request a verification code for a pre-verified phone number via SMS or voice call.
  This is part of the WhatsApp Business Account onboarding process where pre-approved
  phone numbers must be verified before they can be used for messaging.


  **Process Flow:**
  1. Call this endpoint to request a verification code
  2. User receives code via SMS or voice call
  3. Use the verify_code endpoint to complete verification
  4. Phone number becomes active for messaging


  **Rate Limiting:**
  - Limited number of code requests per phone number per time period
  - Exponential backoff recommended for retry attempts
  - Voice calls may have additional restrictions


  **Language Support:**
  Verification messages are sent in the specified language when available.
  Falls back to English (en_US) if the requested language is not supported.


  **Security Considerations:**
  - Codes expire after a short time period
  - Limited number of verification attempts allowed
  - Phone number must be pre-verified and owned by requesting business


  ## Examples

  ### Standard SMS request with English

      %{"code_method" => "SMS", "language" => "en_US"}

  ### Request SMS verification code

      %{"code_method" => "SMS", "language" => "en_US"}

  ### Request voice call verification code

      %{"code_method" => "VOICE", "language" => "es_ES"}
  """
  @spec request_pre_verified_phone_number_code(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.RequestCode.t()}
          | {:ok, WhatsApp.Resources.RequestCode.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def request_pre_verified_phone_number_code(
        client,
        pre_verified_phone_number_id,
        params,
        opts \\ []
      ) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{pre_verified_phone_number_id}/request_code",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.RequestCode)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.RequestCode), resp}

      error ->
        error
    end
  end
end
