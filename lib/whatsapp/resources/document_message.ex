defmodule WhatsApp.Resources.DocumentMessage do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `document` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          document: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :document]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :document
  ]
end
