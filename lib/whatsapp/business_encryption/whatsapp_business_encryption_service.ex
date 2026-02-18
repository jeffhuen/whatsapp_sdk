defmodule WhatsApp.BusinessEncryption.WhatsappBusinessEncryptionService do
  @moduledoc """
  APIs for managing WhatsApp Business Account encryption configuration
  """

  @doc """
  Set Business Encryption Public Key

  Upload and configure a business public key for message payload encryption.

  This endpoint accepts a business public key in PEM format, validates it,
  and stores it with a cryptographic signature for future use in encrypting
  message payloads and data channel requests.

  **Use Cases:**
  - Initial setup of encryption for WhatsApp Business messaging
  - Update existing public key for key rotation
  - Enable secure payload encryption for sensitive business communications
  - Configure encryption keys for compliance requirements

  **Key Requirements:**
  - Must be a valid RSA public key in PEM format
  - Key must meet Meta's security standards for encryption
  - Only one active public key per phone number at a time
  - Previous keys are replaced when new ones are uploaded

  **Rate Limiting:**
  Standard Graph API rate limits apply. Key uploads may have additional
  security-related rate limiting to prevent abuse.


  ## Examples

  ### Upload business public key

      %{
    "business_public_key" => "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----\n"
  }
  """
  @spec set_business_encryption_public_key(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessEncryptionUpload.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessEncryptionUpload.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def set_business_encryption_public_key(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/whatsapp_business_encryption",
           [multipart: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessEncryptionUpload
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessEncryptionUpload
         ), resp}

      error ->
        error
    end
  end
end
