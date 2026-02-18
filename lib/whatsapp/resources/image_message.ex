defmodule WhatsApp.Resources.ImageMessage do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `image` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          image: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :image]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :image
  ]
end
