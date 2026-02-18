defmodule WhatsApp.Resources.PhoneNumberSettings do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `calling` | `map()` |  |
  | `payload_encryption` | `map()` |  |
  | `storage_configuration` | `map()` |  |
  """

  @type t :: %__MODULE__{
          calling: map(),
          payload_encryption: map() | nil,
          storage_configuration: map()
        }
  @enforce_keys [:calling, :storage_configuration]
  defstruct [
    :calling,
    :payload_encryption,
    :storage_configuration
  ]
end
