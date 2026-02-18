defmodule WhatsApp.Resources.CallHoursSettings do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `day_of_week_start` | `String.t()` | Start day of the week |
  | `status` | `String.t()` | Call hours feature status |
  | `timezone` | `String.t()` | Timezone for call hours |

  ## `status` Values
  | Value |
  | --- |
  | `enabled` |
  | `disabled` |
  """

  @type t :: %__MODULE__{
          day_of_week_start: String.t() | nil,
          status: String.t(),
          timezone: String.t() | nil
        }
  @enforce_keys [:status]
  defstruct [
    :day_of_week_start,
    :status,
    :timezone
  ]
end
