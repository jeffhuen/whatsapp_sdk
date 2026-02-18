defmodule WhatsApp.Flows.WhatsappBusinessEncryptionService do
  @moduledoc false

  @doc """
  Get Business Encryption Public Key

  Retrieve the current business public key and its signature verification status.

  This endpoint returns the public key that is currently configured for encrypting
  message payloads and indicates whether the stored signature is valid or has a mismatch.

  **Use Cases:**
  - Verify current encryption configuration
  - Check public key signature validation status
  - Retrieve public key for client-side encryption setup
  - Monitor encryption key status for security compliance

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Caching:**
  Public key information can be cached for moderate periods, but signature status
  may change and should be checked regularly for security validation.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  all available fields will be returned.
  Available fields: business_public_key, business_public_key_signature_status

  """
  @spec get_business_encryption_public_key(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_business_encryption_public_key(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{phone_number_id}/whatsapp_business_encryption",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.WhatsAppBusinessEncryptionInfo
           )
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.WhatsAppBusinessEncryptionInfo
           )
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `get_business_encryption_public_key/2` that auto-pages through all results."
  @spec stream_business_encryption_public_key(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_business_encryption_public_key(client, opts \\ []) do
    case get_business_encryption_public_key(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn:
            &WhatsApp.Deserializer.deserialize(
              &1,
              WhatsApp.Resources.WhatsAppBusinessEncryptionInfo
            )
        )

      error ->
        error
    end
  end
end
