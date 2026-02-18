defmodule WhatsApp.Resources.ReactionMessage1 do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `reaction` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          reaction: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :reaction]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :reaction
  ]
end
