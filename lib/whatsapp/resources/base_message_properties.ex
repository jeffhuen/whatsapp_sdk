defmodule WhatsApp.Resources.BaseMessageProperties do
  @moduledoc """
  Common properties shared by all message types

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `context` | `map()` | Context information for replying to a message |
  | `messaging_product` | `String.t()` |  |
  | `recipient_type` | `String.t()` | The type of recipient. |
  | `to` | `String.t()` | The recipient's phone number for individual messages, and group-id for group message. |
  | `type` | `String.t()` | The type of message |

  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type
  ]
end
