defmodule WhatsApp.Resources.CallHoursSettings do
  @moduledoc """
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
