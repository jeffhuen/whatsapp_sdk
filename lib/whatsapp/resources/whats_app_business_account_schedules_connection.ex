defmodule WhatsApp.Resources.WhatsAppBusinessAccountSchedulesConnection do
  @moduledoc """
  Paginated collection of WhatsApp Business Account schedules
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
