defmodule WhatsApp.Resources.BodyObject do
  @moduledoc """
  An object with the body of the message. Optional for 'product' type, required for other interactive message types.

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `text` | `String.t()` | The content of the message body. Emojis and markdown are supported. |

  ## `text` Constraints

  - Maximum length: 1024
  """

  @type t :: %__MODULE__{
          text: String.t()
        }
  @enforce_keys [:text]
  defstruct [
    :text
  ]
end
