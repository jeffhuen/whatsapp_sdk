defmodule WhatsApp.Resources.TextMessage2 do
  @moduledoc """
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
