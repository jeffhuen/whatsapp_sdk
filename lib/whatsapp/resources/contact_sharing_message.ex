defmodule WhatsApp.Resources.ContactSharingMessage do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `contacts` |
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
