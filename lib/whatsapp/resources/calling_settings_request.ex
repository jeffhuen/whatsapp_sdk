defmodule WhatsApp.Resources.CallingSettingsRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `calling` | `map()` |  |
  """

  @type t :: %__MODULE__{
          calling: map()
        }
  @enforce_keys [:calling]
  defstruct [
    :calling
  ]
end
