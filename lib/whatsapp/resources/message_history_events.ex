defmodule WhatsApp.Resources.MessageHistoryEvents do
  @moduledoc """
  Paginated response containing message history events
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppMessageHistoryEventsEdge.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
