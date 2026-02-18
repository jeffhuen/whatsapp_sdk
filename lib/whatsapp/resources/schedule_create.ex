defmodule WhatsApp.Resources.ScheduleCreate do
  @moduledoc """
  Response after successfully creating a schedule

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the created schedule |
  """

  @type t :: %__MODULE__{
          id: String.t()
        }
  @enforce_keys [:id]
  defstruct [
    :id
  ]
end
