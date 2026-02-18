defmodule WhatsApp.Resources.WhatsAppMessageHistoryEventsEdge do
  @moduledoc """
  Edge containing message delivery status occurrence with pagination cursor

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `cursor` | `String.t()` | Pagination cursor for this edge |
  | `node` | `map()` | Message delivery status occurrence with detailed event information |
  """

  @type t :: %__MODULE__{
          cursor: String.t() | nil,
          node: map()
        }
  @enforce_keys [:node]
  defstruct [
    :cursor,
    :node
  ]
end
