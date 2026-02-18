defmodule WhatsApp.Resources.WhatsAppBusinessSolutions do
  @moduledoc """
  Response containing list of Multi-Partner Solutions with pagination

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of Multi-Partner Solutions |
  | `paging` | `map()` | Cursor-based pagination information |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessSolution.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
