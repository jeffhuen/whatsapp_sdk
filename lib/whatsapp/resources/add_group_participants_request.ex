defmodule WhatsApp.Resources.AddGroupParticipantsRequest do
  @moduledoc """
  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |

  ## `participants` Constraints

  - Minimum items: 1
  - Maximum items: 8
  """

  @type t :: %__MODULE__{
          messaging_product: String.t(),
          participants: list(map())
        }
  @enforce_keys [:messaging_product, :participants]
  defstruct [
    :messaging_product,
    :participants
  ]
end
