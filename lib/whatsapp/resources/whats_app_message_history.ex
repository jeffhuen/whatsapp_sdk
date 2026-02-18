defmodule WhatsApp.Resources.WhatsAppMessageHistory do
  @moduledoc """
  WhatsApp message history entry with delivery status information

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `events` | `map()` | Message delivery status events and occurrences |
  | `id` | `String.t()` | Unique identifier for the message history entry |
  | `message_id` | `String.t()` | WhatsApp message ID (WAMID) for the message |
  """

  @type t :: %__MODULE__{
          events: map() | nil,
          id: String.t(),
          message_id: String.t()
        }
  @enforce_keys [:id, :message_id]
  defstruct [
    :events,
    :id,
    :message_id
  ]
end
