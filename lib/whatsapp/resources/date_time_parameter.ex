defmodule WhatsApp.Resources.DateTimeParameter do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `term()` |  |
  | `date_time` | `map()` |  |

  ## `type` Values
  | Value |
  | --- |
  | `date_time` |
  """

  @type t :: %__MODULE__{
          type: term(),
          date_time: map()
        }
  @enforce_keys [:type, :date_time]
  defstruct [
    :type,
    :date_time
  ]
end
