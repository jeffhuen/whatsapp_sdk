defmodule WhatsApp.Resources.WhatsAppBusinessAccountSchedulesConnection do
  @moduledoc """
  Paginated collection of WhatsApp Business Account schedules

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of schedule records |
  | `paging` | `map()` | Cursor-based pagination information |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessAccountSchedule.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
