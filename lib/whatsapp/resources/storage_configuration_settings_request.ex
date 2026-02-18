defmodule WhatsApp.Resources.StorageConfigurationSettingsRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          storage_configuration: map()
        }
  @enforce_keys [:storage_configuration]
  defstruct [
    :storage_configuration
  ]
end
