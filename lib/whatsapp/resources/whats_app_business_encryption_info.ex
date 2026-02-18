defmodule WhatsApp.Resources.WhatsAppBusinessEncryptionInfo do
  @moduledoc """
  Business encryption public key information and verification status

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `business_public_key` | `String.t()` | The business public key used for encrypting message payloads.
  This key is used to encrypt data channel requests and responses.
   |
  | `business_public_key_signature_status` | `String.t()` | Status of business public key signature verification |

  ## `business_public_key_signature_status` Values
  | Value |
  | --- |
  | `VALID` |
  | `MISMATCH` |
  """

  @type t :: %__MODULE__{
          business_public_key: String.t(),
          business_public_key_signature_status: String.t()
        }
  @enforce_keys [:business_public_key, :business_public_key_signature_status]
  defstruct [
    :business_public_key,
    :business_public_key_signature_status
  ]
end
