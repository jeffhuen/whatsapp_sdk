defmodule WhatsApp.Resources.ButtonTextParameter do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `term()` |  |
  | `text` | `String.t()` | Developer-provided suffix that is appended to the predefined prefix URL in the template. |

  ## `type` Values
  | Value |
  | --- |
  | `text` |
  """

  @type t :: %__MODULE__{
          type: term(),
          text: String.t()
        }
  @enforce_keys [:type, :text]
  defstruct [
    :type,
    :text
  ]
end
