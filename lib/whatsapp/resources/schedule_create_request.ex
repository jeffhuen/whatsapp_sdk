defmodule WhatsApp.Resources.ScheduleCreateRequest do
  @moduledoc """
  Request payload for creating a new schedule

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `days_of_week` | `list()` | Days of the week when the schedule is active |
  | `description` | `String.t()` | Optional description of the schedule purpose |
  | `end_time` | `Time.t()` | Schedule end time in HH:MM format |
  | `is_active` | `boolean()` | Whether the schedule should be active upon creation |
  | `name` | `String.t()` | Human-readable name for the schedule |
  | `recurrence_pattern` | `map()` | Pattern for recurring schedules |
  | `schedule_type` | `String.t()` | Type of schedule configuration |
  | `start_time` | `Time.t()` | Schedule start time in HH:MM format |
  | `timezone` | `String.t()` | Timezone identifier for the schedule |

  ## `schedule_type` Values
  | Value |
  | --- |
  | `BUSINESS_HOURS` |
  | `AUTOMATED_RESPONSE` |
  | `MESSAGE_CAMPAIGN` |
  | `MAINTENANCE_WINDOW` |
  | `CUSTOM` |

  ## `description` Constraints

  - Maximum length: 500

  ## `name` Constraints

  - Minimum length: 1
  - Maximum length: 100
  """

  @type t :: %__MODULE__{
          days_of_week: list(term()) | nil,
          description: String.t() | nil,
          end_time: Time.t(),
          is_active: boolean() | nil,
          name: String.t(),
          recurrence_pattern: map() | nil,
          schedule_type: String.t(),
          start_time: Time.t(),
          timezone: String.t() | nil
        }
  @enforce_keys [:name, :schedule_type, :start_time, :end_time]
  defstruct [
    :days_of_week,
    :description,
    :end_time,
    :name,
    :recurrence_pattern,
    :schedule_type,
    :start_time,
    is_active: true,
    timezone: "UTC"
  ]
end
