defmodule WhatsApp.Resources.PayloadEncryptionSettings do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `client_encryption_key` | `String.t()` | Base64-encoded public key for payload encryption
  (required when enabling encryption)
   |
  | `status` | `String.t()` | Enable or disable payload encryption |

  ## `status` Values
  | Value |
  | --- |
  | `enabled` |
  | `disabled` |
  """

  @type t :: %__MODULE__{
          client_encryption_key: String.t() | nil,
          status: String.t()
        }
  @enforce_keys [:status]
  defstruct [
    :client_encryption_key,
    :status
  ]
end
