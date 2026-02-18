defmodule WhatsApp.Resources.RecurrencePattern do
  @moduledoc """
  Pattern for recurring schedules

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `end_date` | `Date.t()` | End date for the recurrence pattern |
  | `frequency` | `String.t()` |  |
  | `interval` | `integer()` | Interval between recurrences |

  ## `frequency` Values
  | Value |
  | --- |
  | `DAILY` |
  | `WEEKLY` |
  | `MONTHLY` |
  | `YEARLY` |

  ## `interval` Constraints

  - Minimum value: 1
  """

  @type t :: %__MODULE__{
          end_date: Date.t() | nil,
          frequency: String.t() | nil,
          interval: integer() | nil
        }
  defstruct [
    :end_date,
    :frequency,
    :interval
  ]
end
