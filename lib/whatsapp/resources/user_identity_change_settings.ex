defmodule WhatsApp.Resources.UserIdentityChangeSettings do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `enabled` | `boolean()` | Enable or disable user identity change notifications |
  """

  @type t :: %__MODULE__{
          enabled: boolean()
        }
  @enforce_keys [:enabled]
  defstruct [
    :enabled
  ]
end
