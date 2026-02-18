defmodule WhatsApp.Resources.WhatsAppMessageHistoryEventsEdge do
  @moduledoc """
  Edge containing message delivery status occurrence with pagination cursor
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
