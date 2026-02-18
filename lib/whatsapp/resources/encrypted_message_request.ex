defmodule WhatsApp.Resources.EncryptedMessageRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `encrypted_contents` | `String.t()` | JWE payload with encrypted messages structure. This should be a valid JWE token containing the encrypted message payload. |
  | `messaging_product` | `String.t()` | Messaging service used for the request. Use whatsapp. |

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |
  """

  @type t :: %__MODULE__{
          encrypted_contents: String.t(),
          messaging_product: String.t()
        }
  @enforce_keys [:messaging_product, :encrypted_contents]
  defstruct [
    :encrypted_contents,
    :messaging_product
  ]
end
