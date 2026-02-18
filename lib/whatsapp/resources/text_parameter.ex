defmodule WhatsApp.Resources.TextParameter do
  @moduledoc """
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
