defmodule WhatsApp.EncryptedMessages.MessagesEncryptedService do
  @moduledoc """
  Payload encryption provides an additional layer of security on top of existing standard TLS/SSL that secures communication between Cloud API and businesses. When enabled, all message requests and message echoes webhooks will undergo encryption using JWE (JSON Web Encryption) format.

  ## Key Features

  - **Additional Security Layer**: Adds payload-level encryption on top of standard TLS/SSL
  - **JWE Format**: Uses JSON Web Encryption standard for encrypting message payloads
  - **Selective Encryption**: Only successful responses are encrypted; errors remain unencrypted
  - **Standard Compatibility**: Encrypted payloads contain the same structure as `/messages` endpoint
  - **Phone-Number Level**: Encryption is configured per phone number within a WABA

  ## Setup Requirements

  1. **Enable Payload Encryption**: Use `POST /<Phone-Number-ID>/settings` to enable encryption
  2. **RSA Key Pair**: Generate and provide a 2048-bit RSA public key (base64 encoded)
  3. **Algorithm Support**: Multiple algorithms supported for content and key encryption
  4. **Access Token**: User Access Token with `whatsapp_business_messaging` permission

  ## Supported Algorithms

  - **Content Encryption**: A128GCM, A256GCM, A128CBC-HS256, A192CBC-HS384, A256CBC-HS512
  - **Key Encryption**: RSA1_5, RSA-OAEP
  - **WhatsApp Standard**: A256GCM + RSA-OAEP for responses and webhooks
  """

  @doc """
  Send Encrypted Message

  Send encrypted messages using JWE (JSON Web Encryption) format. This endpoint provides an additional layer of security on top of existing standard TLS/SSL by accepting pre-encrypted message payloads and returning encrypted responses.

  **Important Notes:**
  - Only successful responses will be encrypted
  - Error responses will be returned unencrypted if the underlying JSON is incorrectly formatted
  - Payload encryption must be enabled for the phone number using the `POST /<Phone-Number-ID>/settings` endpoint
  - The encrypted payload must follow the same structure as the original `/messages` endpoint

  **Prerequisites:**
  - User Access Token with `whatsapp_business_messaging` permission
  - Valid `Phone-Number-ID` for your registered WhatsApp Business account
  - Payload encryption enabled for the phone number
  - Properly formatted JWE token containing encrypted message payload using supported algorithms

  **Supported Algorithms:**
  - **Content Encryption:** A128GCM, A256GCM...

  ## Examples

  ### Send an encrypted media message

      %{
    "encrypted_contents" => "eyJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.encrypted_media_payload...",
    "messaging_product" => "whatsapp"
  }

  ### Send an encrypted template message

      %{
    "encrypted_contents" => "eyJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ.encrypted_template_payload...",
    "messaging_product" => "whatsapp"
  }

  ### Send an encrypted text message

      %{
    "encrypted_contents" => "eyJhbGciOiJSU0EtT0FFUCIsImVuYyI6IkExMjhDQkMtSFMyNTYifQ...",
    "messaging_product" => "whatsapp"
  }
  """
  @spec send_encrypted_message(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.EncryptedMessage.t()}
          | {:ok, WhatsApp.Resources.EncryptedMessage.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def send_encrypted_message(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/messages_encrypted",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.EncryptedMessage)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.EncryptedMessage), resp}

      error ->
        error
    end
  end
end
