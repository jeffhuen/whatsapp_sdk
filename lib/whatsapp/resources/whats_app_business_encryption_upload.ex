defmodule WhatsApp.Resources.WhatsAppBusinessEncryptionUpload do
  @moduledoc """
  Response after successful public key upload
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
