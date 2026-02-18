defmodule WhatsApp.Resources.MarkMessageRequestPayload do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `message_id` | `String.t()` |  |
  | `messaging_product` | `String.t()` |  |
  | `status` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          message_id: String.t(),
          messaging_product: String.t(),
          status: String.t()
        }
  @enforce_keys [:message_id, :messaging_product, :status]
  defstruct [
    :message_id,
    :messaging_product,
    :status
  ]
end
