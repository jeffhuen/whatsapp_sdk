defmodule WhatsApp.Resources.MarketingMessageRequestPayload do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `message_activity_sharing` | `boolean()` | Optional flag to control message activity sharing |
  | `messaging_product` | `String.t()` | Messaging service used. Must be "whatsapp" |
  | `product_policy` | `String.t()` | Optional product policy setting |
  | `recipient_type` | `String.t()` | Type of recipient. Must be "individual" |
  | `template` | `map()` |  |
  | `to` | `String.t()` | WhatsApp ID or phone number of the message recipient |
  | `type` | `String.t()` | Type of message. Must be "template" for marketing messages |

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |

  ## `product_policy` Values
  | Value |
  | --- |
  | `CLOUD_API_FALLBACK` |
  | `STRICT` |

  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |

  ## `type` Values
  | Value |
  | --- |
  | `template` |
  """

  @type t :: %__MODULE__{
          message_activity_sharing: boolean() | nil,
          messaging_product: String.t(),
          product_policy: String.t() | nil,
          recipient_type: String.t(),
          template: map(),
          to: String.t(),
          type: String.t()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :template]
  defstruct [
    :message_activity_sharing,
    :messaging_product,
    :product_policy,
    :recipient_type,
    :template,
    :to,
    type: "template"
  ]
end
