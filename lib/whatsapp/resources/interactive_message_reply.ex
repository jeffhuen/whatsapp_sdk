defmodule WhatsApp.Resources.InteractiveMessageReply do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `context` | `map()` |  |
  | `messaging_product` | `String.t()` |  |
  | `recipient_type` | `String.t()` | The type of recipient. |
  | `to` | `String.t()` | The recipient's phone number for individual messages, and group-id for group message. |
  | `type` | `String.t()` |  |
  | `interactive` | `map()` |  |

  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `interactive` |
  """

  @type t :: %__MODULE__{
          context: map(),
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          interactive: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :context, :interactive]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :interactive
  ]
end
