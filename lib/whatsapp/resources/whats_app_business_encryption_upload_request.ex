defmodule WhatsApp.Resources.WhatsAppBusinessEncryptionUploadRequest do
  @moduledoc """
  Request payload for uploading business public key

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `business_public_key` | `String.t()` | The business public key in PEM format to be uploaded and signed.
  Must be a valid RSA public key that will be used for payload encryption.
   |
  """

  @type t :: %__MODULE__{
          business_public_key: String.t()
        }
  @enforce_keys [:business_public_key]
  defstruct [
    :business_public_key
  ]
end
