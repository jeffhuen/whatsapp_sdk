defmodule WhatsApp.Resources.CallingRestrictions do
  @moduledoc false

  @type t :: %__MODULE__{
          restrictions: list(map()) | nil
        }
  defstruct [
    :restrictions
  ]
end
