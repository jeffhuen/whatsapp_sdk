defmodule WhatsApp.Resources.ContactsMessage do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `context` | `map()` | Context information for replying to a message |
  | `messaging_product` | `String.t()` |  |
  | `recipient_type` | `String.t()` | The type of recipient. |
  | `to` | `String.t()` | The recipient's phone number for individual messages, and group-id for group message. |
  | `type` | `String.t()` |  |
  | `contacts` | `list()` |  |

  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `contacts` |

  ## `contacts` Constraints

  - Minimum items: 1
  - Maximum items: 5
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          contacts: list(WhatsApp.Resources.ContactObject.t())
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :contacts]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :contacts
  ]
end
