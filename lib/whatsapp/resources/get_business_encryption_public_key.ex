defmodule WhatsApp.Resources.GetBusinessEncryptionPublicKey do
  @moduledoc false

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessEncryptionInfo.t()) | nil
        }
  defstruct [
    :data
  ]
end
