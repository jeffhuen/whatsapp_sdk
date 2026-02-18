defmodule WhatsApp.Resources.BodyComponent do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `index` | `String.t()` | Required when `type=button`. Not used for other types. Position index of the button (0-9). |
  | `parameters` | `list()` | Parameters for the body component, which can be `text`, `currency`, or `date_time`. [17] |
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
