defmodule WhatsApp.Resources.EncryptedMessage do
  @moduledoc false

  @type t :: %__MODULE__{
          encrypted_contents: String.t()
        }
  @enforce_keys [:encrypted_contents]
  defstruct [
    :encrypted_contents
  ]
end
