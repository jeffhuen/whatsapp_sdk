defmodule WhatsApp.Resources.GetBusinessEncryptionPublicKey do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` |  |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessEncryptionInfo.t()) | nil
        }
  defstruct [
    :data
  ]
end
