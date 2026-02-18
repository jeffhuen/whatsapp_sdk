defmodule WhatsApp.Resources.MarketingMessageRequestPayload do
  @moduledoc """
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
