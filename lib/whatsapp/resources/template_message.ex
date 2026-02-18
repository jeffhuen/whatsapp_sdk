defmodule WhatsApp.Resources.TemplateMessage do
  @moduledoc """
  ## `recipient_type` Values
  | Value |
  | --- |
  | `individual` |
  | `group` |

  ## `type` Values
  | Value |
  | --- |
  | `template` |
  """

  @type t :: %__MODULE__{
          context: map() | nil,
          messaging_product: String.t(),
          recipient_type: String.t(),
          to: String.t(),
          type: String.t(),
          template: map()
        }
  @enforce_keys [:messaging_product, :recipient_type, :to, :type, :template]
  defstruct [
    :context,
    :messaging_product,
    :recipient_type,
    :to,
    :type,
    :template
  ]
end
