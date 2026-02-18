defmodule WhatsApp.Resources.MessageRequest do
  @moduledoc """
  Request to send a message via WhatsApp Business API

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |

  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `text` |
  | `image` |
  | `audio` |
  | `video` |
  | `document` |
  | `location` |
  | `contacts` |
  | `template` |
  | `interactive` |
  | `reaction` |
  | `sticker` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t() | nil,
          text: map() | nil,
          to: String.t(),
          type: String.t()
        }
  @enforce_keys [:messaging_product, :to, :type]
  defstruct [
    :context,
    :messaging_product,
    :text,
    :to,
    :type,
    recipient_type: "individual"
  ]
end
