defmodule WhatsApp.Resources.IncomingMessageValueGeneral do
  @moduledoc false

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
