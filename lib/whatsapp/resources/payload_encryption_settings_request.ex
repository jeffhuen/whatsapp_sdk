defmodule WhatsApp.Resources.PayloadEncryptionSettingsRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          payload_encryption: map()
        }
  @enforce_keys [:payload_encryption]
  defstruct [
    :payload_encryption
  ]
end
