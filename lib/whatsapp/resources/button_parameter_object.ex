defmodule WhatsApp.Resources.ButtonParameterObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `String.t()` | Indicates the type of parameter for the button. |

  ## `type` Values
  | Value |
  | --- |
  | `payload` |
  | `text` |
  """

  @type t :: %__MODULE__{
          type: String.t()
        }
  @enforce_keys [:type]
  defstruct [
    :type
  ]
end
