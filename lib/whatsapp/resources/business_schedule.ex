defmodule WhatsApp.Resources.BusinessSchedule do
  @moduledoc """
  Business hours schedule information

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `close_time` | `String.t()` | Closing time in HH:MM format |
  | `day_of_week` | `String.t()` |  |
  | `open_time` | `String.t()` | Opening time in HH:MM format |

  ## `day_of_week` Values
  | Value |
  | --- |
  | `MONDAY` |
  | `TUESDAY` |
  | `WEDNESDAY` |
  | `THURSDAY` |
  | `FRIDAY` |
  | `SATURDAY` |
  | `SUNDAY` |

  ## `close_time` Constraints

  - Pattern: `^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$`

  ## `open_time` Constraints

  - Pattern: `^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$`
  """

  @type t :: %__MODULE__{
          close_time: String.t() | nil,
          day_of_week: String.t() | nil,
          open_time: String.t() | nil
        }
  defstruct [
    :close_time,
    :day_of_week,
    :open_time
  ]
end
