defmodule WhatsApp.PhoneNumberVerification.RequestCodeService do
  @moduledoc """
  APIs for WhatsApp Business phone number verification process
  """

  @doc """
  Request Phone Number Verification Code

  Request a verification code for a WhatsApp Business phone number via SMS or voice call.
  This is the first step in the phone number verification process.


  **Use Cases:**
  - Initial verification of newly added phone numbers
  - Re-verification when phone number status requires it
  - Switching between SMS and voice verification methods

  **Rate Limiting:**
  Standard Graph API rate limits apply. Additional rate limiting may be enforced
  for verification code requests to prevent abuse.

  **Security:**
  Verification codes are sent only to the registered phone number and expire
  after a short time period. Multiple failed attempts may result in temporary blocking.


  ## Examples

  ### Request SMS verification code

      %{"code_method" => "SMS", "language" => "en_US"}

  ### Request voice verification code

      %{"code_method" => "VOICE", "language" => "es_ES"}
  """
  @spec request_verification_code(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.RequestCode.t()}
          | {:ok, WhatsApp.Resources.RequestCode.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def request_verification_code(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/request_code",
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
