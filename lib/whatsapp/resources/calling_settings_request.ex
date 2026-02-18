defmodule WhatsApp.Resources.CallingSettingsRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          calling: map()
        }
  @enforce_keys [:calling]
  defstruct [
    :calling
  ]
end
