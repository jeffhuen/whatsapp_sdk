defmodule WhatsApp.Resources.BodyComponent do
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
  | `body` |

  ## `index` Constraints

  - Pattern: `^[2-6, 11-14]$`
  """

  @type t :: %__MODULE__{
          index: String.t() | nil,
          parameters: list(WhatsApp.Resources.ParameterObject.t()) | nil,
          sub_type: String.t() | nil,
          type: term()
        }
  @enforce_keys [:type]
  defstruct [
    :index,
    :parameters,
    :sub_type,
    :type
  ]
end
