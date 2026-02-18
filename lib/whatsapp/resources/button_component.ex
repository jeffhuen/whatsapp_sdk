defmodule WhatsApp.Resources.ButtonComponent do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `index` | `String.t()` |  |
  | `parameters` | `list()` | Parameters for the button component, which are `payload` for quick reply or `text` for URL buttons. |
  | `sub_type` | `String.t()` |  |
  | `type` | `term()` |  |

  ## `sub_type` Values
  | Value |
  | --- |
  | `quick_reply` |
  | `url` |
  | `catalog` |

  ## `type` Values
  | Value |
  | --- |
  | `button` |

  ## `index` Constraints

  - Pattern: `^[2-6, 11-14]$`

  ## `parameters` Constraints

  - Minimum items: 1
  """

  @type t :: %__MODULE__{
          index: String.t(),
          parameters: list(WhatsApp.Resources.ButtonParameterObject.t()),
          sub_type: String.t(),
          type: term()
        }
  @enforce_keys [:type, :sub_type, :index, :parameters]
  defstruct [
    :index,
    :parameters,
    :sub_type,
    :type
  ]
end
