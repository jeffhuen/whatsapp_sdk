defmodule WhatsApp.Resources.SystemMessage do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `system` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          system: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :system]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :system
  ]
end
