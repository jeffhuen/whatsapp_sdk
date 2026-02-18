defmodule WhatsApp.PreVerifiedPhoneNumbers.VerifyCodeService do
  @moduledoc """
  APIs for managing pre-verified phone numbers for WhatsApp Business messaging
  """

  @doc """
  Verify OTP Code for Pre-Verified Phone Number

  Verify the OTP code received for a pre-verified phone number to complete the
  verification process. This endpoint validates the code and updates the verification
  status of the phone number.


  **Use Cases:**
  - Complete phone number verification during WhatsApp Business onboarding
  - Verify ownership of phone numbers for business messaging
  - Enable phone numbers for WhatsApp Business API usage


  **Rate Limiting:**
  This endpoint has specific rate limits to prevent abuse:
  - 125 requests per hour for business use cases
  - Standard Graph API rate limits also apply


  **Code Validation:**
  - Codes are time-sensitive and expire after a set period
  - Each code can only be used once
  - Invalid or expired codes will result in verification failure


  **Error Handling:**
  - Invalid codes return 400 Bad Request
  - Expired codes return 422 Unprocessable Entity
  - Rate limit exceeded returns 429 Too Many Requests


  ## Examples

  ### Verify received OTP code

      %{"code" => "123456"}
  """
  @spec verify_pre_verified_phone_number_code(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.VerifyCode.t()}
          | {:ok, WhatsApp.Resources.VerifyCode.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def verify_pre_verified_phone_number_code(
        client,
        pre_verified_phone_number_id,
        params,
        opts \\ []
      ) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{pre_verified_phone_number_id}/verify_code",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.VerifyCode)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.VerifyCode), resp}

      error ->
        error
    end
  end
end
