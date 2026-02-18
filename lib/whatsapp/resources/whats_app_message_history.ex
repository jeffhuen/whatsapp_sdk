defmodule WhatsApp.Resources.WhatsAppMessageHistory do
  @moduledoc """
  WhatsApp message history entry with delivery status information
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
