defmodule WhatsApp.Resources.CallRequestPayload do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `action` | `String.t()` | The action being taken on the given call ID |
  | `biz_opaque_callback_data` | `String.t()` | An arbitrary string you can pass in that is useful for tracking and logging purposes. Any app subscribed to the "calls" webhook field on your WhatsApp Business Account can receive this string, as it is included in the calls object within the subsequent Call Terminate Webhook payload. Cloud API does not process this field. Maximum 512 characters
   |
  | `messaging_product` | `String.t()` | Messaging product |
  | `session` | `map()` | Contains the session description protocol (SDP) type and description language |
  | `to` | `String.t()` | The number being called (callee) |

  ## `action` Values
  | Value |
  | --- |
  | `connect` |
  | `pre_accept` |
  | `accept` |
  | `reject` |
  | `terminate` |

  ## `biz_opaque_callback_data` Constraints

  - Maximum length: 512
  """

  @type t :: %__MODULE__{
          action: String.t(),
          biz_opaque_callback_data: String.t() | nil,
          messaging_product: String.t(),
          session: map() | nil,
          to: String.t()
        }
  @enforce_keys [:messaging_product, :to, :action]
  defstruct [
    :action,
    :biz_opaque_callback_data,
    :messaging_product,
    :session,
    :to
  ]
end
