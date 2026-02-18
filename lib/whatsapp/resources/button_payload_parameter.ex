defmodule WhatsApp.Resources.ButtonPayloadParameter do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `term()` |  |
  | `payload` | `String.t()` | Developer-defined payload that is returned when the quick reply button is clicked. |

  ## `type` Values
  | Value |
  | --- |
  | `payload` |
  """

  @type t :: %__MODULE__{
          type: term(),
          payload: String.t()
        }
  @enforce_keys [:type, :payload]
  defstruct [
    :type,
    :payload
  ]
end
