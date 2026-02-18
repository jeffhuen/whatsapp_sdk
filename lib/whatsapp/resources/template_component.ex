defmodule WhatsApp.Resources.TemplateComponent do
  @moduledoc """
  ## `sub_type` Values
  | Value |
  | --- |
  | `quick_reply` |
  | `url` |
  | `catalog` |

  ## `type` Values
  | Value |
  | --- |
  | `header` |
  | `body` |
  | `button` |

  ## `index` Constraints

  - Pattern: `^[2-6, 11-14]$`
  """

  @type t :: %__MODULE__{
          index: String.t() | nil,
          parameters: term() | nil,
          sub_type: String.t() | nil,
          type: String.t()
        }
  @enforce_keys [:type]
  defstruct [
    :index,
    :parameters,
    :sub_type,
    :type
  ]
end
