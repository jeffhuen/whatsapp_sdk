defmodule WhatsApp.Resources.HeaderComponent do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `index` | `String.t()` | Required when `type=button`. Not used for other types. Position index of the button (0-9). |
  | `parameters` | `list()` | Parameters for the header component, which can be `image`, `video`, `document`, or `text`. [15, 16] |
  | `sub_type` | `String.t()` | Required when `type=button`. Not used for other types. Type of button to create. |
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
