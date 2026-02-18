defmodule WhatsApp.Resources.IncomingMessageValueSystem do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `messages` | `list()` | Array containing only 'system' message objects. |
  | `messaging_product` | `String.t()` | Always 'whatsapp'. |
  | `metadata` | `map()` |  |
  """

  @type t :: %__MODULE__{
          messages: list(WhatsApp.Resources.SystemMessage.t()),
          messaging_product: String.t(),
          metadata: map()
        }
  @enforce_keys [:messaging_product, :metadata, :messages]
  defstruct [
    :messages,
    :messaging_product,
    :metadata
  ]
end
