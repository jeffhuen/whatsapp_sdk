defmodule WhatsApp.PhoneNumberVerification.VerifyCodeService do
  @moduledoc """
  APIs for WhatsApp Business phone number verification process
  """

  @doc """
  Verify Phone Number Verification Code

  Verify a phone number verification code for a WhatsApp Business Account phone number.
  This endpoint is used to complete the phone number verification process by submitting
  the verification code received via SMS or voice call.


  **Use Cases:**
  - Complete phone number verification during initial setup
  - Verify phone number ownership for messaging capabilities
  - Finalize phone number registration process
  - Complete phone number migration verification


  **Rate Limiting:**
  Verification attempts are rate-limited to prevent abuse. Failed attempts may result
  in temporary blocking. Use appropriate retry logic with exponential backoff.


  **Security:**
  Verification codes are time-limited (typically 10 minutes) and single-use.
  Multiple failed attempts may trigger additional security measures.


  ## Examples

  ### Verify phone number with 6-digit code

      %{"code" => "123456"}
  """
  @spec verify_phone_number_code(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.VerifyCode.t()}
          | {:ok, WhatsApp.Resources.VerifyCode.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def verify_phone_number_code(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/verify_code",
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
