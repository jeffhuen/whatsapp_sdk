defmodule WhatsApp.Resources.StickerMessage1 do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `sticker` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          sticker: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :sticker]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :sticker
  ]
end
