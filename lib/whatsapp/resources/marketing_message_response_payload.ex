defmodule WhatsApp.Resources.MarketingMessageResponsePayload do
  @moduledoc false

  @type t :: %__MODULE__{
          contacts: list(map()) | nil,
          messages: list(map()) | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :contacts,
    :messages,
    :messaging_product
  ]
end
