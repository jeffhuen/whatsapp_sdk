defmodule WhatsApp.Resources.FooterObject do
  @moduledoc """
  An object with the footer of the message. Optional.

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `text` | `String.t()` | The footer content. Emojis, markdown, and links are supported. |

  ## `text` Constraints

  - Maximum length: 60
  """

  @type t :: %__MODULE__{
          text: String.t()
        }
  @enforce_keys [:text]
  defstruct [
    :text
  ]
end
