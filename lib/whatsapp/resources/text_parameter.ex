defmodule WhatsApp.Resources.TextParameter do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `term()` |  |
  | `text` | `String.t()` | The message's text. |

  ## `type` Values
  | Value |
  | --- |
  | `text` |

  ## `text` Constraints

  - Maximum length: 32768
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
