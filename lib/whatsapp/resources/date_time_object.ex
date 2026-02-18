defmodule WhatsApp.Resources.DateTimeObject do
  @moduledoc false

  @type t :: %__MODULE__{
          fallback_value: String.t()
        }
  @enforce_keys [:fallback_value]
  defstruct [
    :fallback_value
  ]
end
