defmodule WhatsApp.Resources.RecurrencePattern do
  @moduledoc """
  Pattern for recurring schedules

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
