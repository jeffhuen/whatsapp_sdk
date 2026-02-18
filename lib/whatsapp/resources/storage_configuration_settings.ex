defmodule WhatsApp.Resources.StorageConfigurationSettings do
  @moduledoc false

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
