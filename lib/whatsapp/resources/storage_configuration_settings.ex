defmodule WhatsApp.Resources.StorageConfigurationSettings do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `enabled` | `boolean()` | Enable or disable custom storage configuration |
  | `region` | `String.t()` | Data storage region |
  """

  @type t :: %__MODULE__{
          enabled: boolean(),
          region: String.t() | nil
        }
  @enforce_keys [:enabled]
  defstruct [
    :enabled,
    :region
  ]
end
