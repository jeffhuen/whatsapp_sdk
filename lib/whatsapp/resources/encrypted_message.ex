defmodule WhatsApp.Resources.EncryptedMessage do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `encrypted_contents` | `String.t()` | JWE payload with encrypted messages response structure. Contains the encrypted response from the WhatsApp Business API. |
  """

  @type t :: %__MODULE__{
          encrypted_contents: String.t()
        }
  @enforce_keys [:encrypted_contents]
  defstruct [
    :encrypted_contents
  ]
end
