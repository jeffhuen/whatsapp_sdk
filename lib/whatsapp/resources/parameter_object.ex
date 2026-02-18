defmodule WhatsApp.Resources.ParameterObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `String.t()` | Describes the parameter type. For text-based templates, only `"currency"`, `"date_time"`, and `"text"` are supported. |

  ## `type` Values
  | Value |
  | --- |
  | `currency` |
  | `date_time` |
  | `document` |
  | `image` |
  | `text` |
  | `video` |
  """

  @type t :: %__MODULE__{
          type: String.t()
        }
  @enforce_keys [:type]
  defstruct [
    :type
  ]
end
