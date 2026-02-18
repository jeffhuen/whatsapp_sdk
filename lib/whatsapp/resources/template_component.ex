defmodule WhatsApp.Resources.TemplateComponent do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `index` | `String.t()` | Required when `type=button`. Not used for other types. Position index of the button (0-9). |
  | `parameters` | `term()` | Array of parameter objects with the content of the message. |
  | `sub_type` | `String.t()` | Required when `type=button`. Not used for other types. Type of button to create. |
  | `type` | `String.t()` | Describes the component type. |

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
