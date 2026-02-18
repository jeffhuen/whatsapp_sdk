defmodule WhatsApp.Resources.Message do
  @moduledoc """
  Response from sending a message

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |
  """

  @type t :: %__MODULE__{
          contacts: list(WhatsApp.Resources.Contact.t()),
          messages: list(WhatsApp.Resources.MessageResponseItem.t()),
          messaging_product: String.t()
        }
  @enforce_keys [:messaging_product, :contacts, :messages]
  defstruct [
    :contacts,
    :messages,
    :messaging_product
  ]
end
