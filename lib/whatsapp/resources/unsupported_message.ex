defmodule WhatsApp.Resources.UnsupportedMessage do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `unsupported` |
  | `unknown` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          errors: list(WhatsApp.Resources.ErrorObject.t())
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :errors]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :errors
  ]
end
