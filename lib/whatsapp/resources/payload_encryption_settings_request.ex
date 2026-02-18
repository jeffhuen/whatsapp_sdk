defmodule WhatsApp.Resources.PayloadEncryptionSettingsRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `payload_encryption` | `map()` |  |
  """

  @type t :: %__MODULE__{
          payload_encryption: map()
        }
  @enforce_keys [:payload_encryption]
  defstruct [
    :payload_encryption
  ]
end
