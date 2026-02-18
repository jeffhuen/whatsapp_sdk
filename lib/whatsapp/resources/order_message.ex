defmodule WhatsApp.Resources.OrderMessage do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `order` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          order: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :order]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :order
  ]
end
