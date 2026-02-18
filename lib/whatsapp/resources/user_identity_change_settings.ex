defmodule WhatsApp.Resources.UserIdentityChangeSettings do
  @moduledoc false

  @type t :: %__MODULE__{
          enabled: boolean()
        }
  @enforce_keys [:enabled]
  defstruct [
    :enabled
  ]
end
