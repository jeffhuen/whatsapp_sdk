defmodule WhatsApp.Resources.MessageHistory do
  @moduledoc """
  Paginated response containing message history entries

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of message history entries |
  | `paging` | `map()` | Pagination information for navigating through results |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppMessageHistory.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
