defmodule WhatsApp.Resources.HeaderComponent do
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

  ## `index` Constraints

  - Pattern: `^[2-6, 11-14]$`

  ## `parameters` Constraints

  - Minimum items: 1
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
