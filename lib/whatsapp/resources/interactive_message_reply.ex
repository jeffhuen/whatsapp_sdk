defmodule WhatsApp.Resources.InteractiveMessageReply do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `interactive` |
  """

  @type t :: %__MODULE__{
          context: map(),
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          interactive: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :context, :interactive]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :interactive
  ]
end
