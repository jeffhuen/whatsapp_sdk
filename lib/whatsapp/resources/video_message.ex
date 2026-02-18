defmodule WhatsApp.Resources.VideoMessage do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `context` | `map()` | Context information for replying to a message |
  | `messaging_product` | `String.t()` |  |
  | `recipient_type` | `String.t()` | The type of recipient. |
  | `to` | `String.t()` | The recipient's phone number for individual messages, and group-id for group message. |
  | `type` | `String.t()` |  |
  | `video` | `map()` | A media object. Either `id` or `link` is required. |

  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `video` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          video: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :video]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :video
  ]
end
