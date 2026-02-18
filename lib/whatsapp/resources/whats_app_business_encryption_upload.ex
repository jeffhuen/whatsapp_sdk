defmodule WhatsApp.Resources.WhatsAppBusinessEncryptionUpload do
  @moduledoc """
  Response after successful public key upload

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` | Indicates whether the public key was successfully uploaded and signed |
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
