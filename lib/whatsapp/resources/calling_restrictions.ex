defmodule WhatsApp.Resources.CallingRestrictions do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `restrictions` | `list()` |  |
  """

  @type t :: %__MODULE__{
          restrictions: list(map()) | nil
        }
  defstruct [
    :restrictions
  ]
end
