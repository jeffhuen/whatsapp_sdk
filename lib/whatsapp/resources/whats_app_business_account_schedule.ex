defmodule WhatsApp.Resources.WhatsAppBusinessAccountSchedule do
  @moduledoc """
  WhatsApp Business Account schedule configuration and details

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `created_time` | `DateTime.t()` | ISO 8601 timestamp when the schedule was created |
  | `days_of_week` | `list()` | Days of the week when the schedule is active |
  | `description` | `String.t()` | Optional description of the schedule purpose |
  | `end_time` | `Time.t()` | Schedule end time in HH:MM format |
  | `id` | `String.t()` | Unique identifier for the schedule |
  | `is_active` | `boolean()` | Whether the schedule is currently active |
  | `name` | `String.t()` | Human-readable name for the schedule |
  | `recurrence_pattern` | `map()` | Pattern for recurring schedules |
  | `schedule_type` | `String.t()` | Type of schedule configuration |
  | `start_time` | `Time.t()` | Schedule start time in HH:MM format |
  | `status` | `String.t()` | Current status of the schedule |
  | `timezone` | `String.t()` | Timezone identifier for the schedule |
  | `updated_time` | `DateTime.t()` | ISO 8601 timestamp when the schedule was last updated |

  ## `schedule_type` Values
  | Value |
  | --- |
  | `BUSINESS_HOURS` |
  | `AUTOMATED_RESPONSE` |
  | `MESSAGE_CAMPAIGN` |
  | `MAINTENANCE_WINDOW` |
  | `CUSTOM` |

  ## `status` Values
  | Value |
  | --- |
  | `ACTIVE` |
  | `INACTIVE` |
  | `PAUSED` |
  | `EXPIRED` |
  | `DRAFT` |

  ## `description` Constraints

  - Maximum length: 500

  ## `name` Constraints

  - Minimum length: 1
  - Maximum length: 100
  """

  @type t :: %__MODULE__{
          created_time: DateTime.t() | nil,
          days_of_week: list(term()) | nil,
          description: String.t() | nil,
          end_time: Time.t() | nil,
          id: String.t(),
          is_active: boolean() | nil,
          name: String.t(),
          recurrence_pattern: map() | nil,
          schedule_type: String.t(),
          start_time: Time.t() | nil,
          status: String.t(),
          timezone: String.t() | nil,
          updated_time: DateTime.t() | nil
        }
  @enforce_keys [:id, :name, :status, :schedule_type]
  defstruct [
    :created_time,
    :days_of_week,
    :description,
    :end_time,
    :id,
    :is_active,
    :name,
    :recurrence_pattern,
    :schedule_type,
    :start_time,
    :status,
    :timezone,
    :updated_time
  ]
end
