defmodule WhatsApp.Resources.ButtonMessage do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `context` | `map()` |  |
  | `messaging_product` | `String.t()` |  |
  | `recipient_type` | `String.t()` | The type of recipient. |
  | `to` | `String.t()` | The recipient's phone number for individual messages, and group-id for group message. |
  | `type` | `String.t()` |  |
  | `button` | `map()` |  |

  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `button` |
  """

  @type t :: %__MODULE__{
          context: map(),
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          button: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :context, :button]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :button
  ]
end
