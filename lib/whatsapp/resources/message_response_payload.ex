defmodule WhatsApp.Resources.MessageResponsePayload do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `contacts` | `list()` |  |
  | `messages` | `list()` |  |
  | `messaging_product` | `String.t()` |  |
  """

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
