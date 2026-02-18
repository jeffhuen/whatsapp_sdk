defmodule WhatsApp.Resources.MessageHistoryEvents do
  @moduledoc """
  Paginated response containing message history events

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of message history event edges |
  | `paging` | `map()` | Pagination information for navigating through results |
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
