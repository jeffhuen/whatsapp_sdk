defmodule WhatsApp.Resources.WhatsAppBusinessAccountSchedule do
  @moduledoc """
  WhatsApp Business Account schedule configuration and details

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
