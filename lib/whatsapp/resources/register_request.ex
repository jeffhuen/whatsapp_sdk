defmodule WhatsApp.Resources.RegisterRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `messaging_product` | `String.t()` | Messaging service used for the request |
  | `pin` | `String.t()` | 6-digit PIN for two-step verification |

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |

  ## `pin` Constraints

  - Pattern: `^[0-9]{6}$`
  """

  @type t :: %__MODULE__{
          messaging_product: String.t(),
          pin: String.t()
        }
  @enforce_keys [:messaging_product, :pin]
  defstruct [
    :messaging_product,
    :pin
  ]
end
