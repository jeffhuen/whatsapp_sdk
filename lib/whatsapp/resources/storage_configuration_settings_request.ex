defmodule WhatsApp.Resources.StorageConfigurationSettingsRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `storage_configuration` | `map()` |  |
  """

  @type t :: %__MODULE__{
          storage_configuration: map()
        }
  @enforce_keys [:storage_configuration]
  defstruct [
    :storage_configuration
  ]
end
