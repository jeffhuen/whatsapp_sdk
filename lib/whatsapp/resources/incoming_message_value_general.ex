defmodule WhatsApp.Resources.IncomingMessageValueGeneral do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `contacts` | `list()` | Array of contact profiles for the sender. Included for all non-system incoming messages. |
  | `messages` | `list()` | Array of message objects. The structure varies based on the 'type' property. |
  | `messaging_product` | `String.t()` | Always 'whatsapp'. |
  | `metadata` | `map()` |  |
  """

  @type t :: %__MODULE__{
          contacts: list(WhatsApp.Resources.ContactProfile.t()),
          messages: list(term()),
          messaging_product: String.t(),
          metadata: map()
        }
  @enforce_keys [:messaging_product, :metadata, :contacts, :messages]
  defstruct [
    :contacts,
    :messages,
    :messaging_product,
    :metadata
  ]
end
