defmodule WhatsApp.Resources.TextMessage2 do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `context` | `map()` | Only included if message via a "Message business" button. |
  | `messaging_product` | `String.t()` |  |
  | `recipient_type` | `String.t()` | The type of recipient. |
  | `to` | `String.t()` | The recipient's phone number for individual messages, and group-id for group message. |
  | `type` | `String.t()` |  |
  | `referral` | `map()` | Only included if message via a Click to WhatsApp ad. |
  | `text` | `map()` |  |

  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `text` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          referral: map() | nil,
          text: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :text]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :referral,
    :text
  ]
end
