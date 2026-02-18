defmodule WhatsApp.Resources.PhoneNumberSettings do
  @moduledoc false

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
