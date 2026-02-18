defmodule WhatsApp.Resources.PreVerifiedPhoneNumberShareRequest do
  @moduledoc """
  Request payload for sharing a pre-verified phone number with another business

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `partner_business_id` | `String.t()` | Business ID of the partner business that will receive access to the pre-verified phone number.
  Must be a valid business entity accessible to the requesting app.
   |
  | `preverified_id` | `String.t()` | Unique identifier of the pre-verified phone number to be shared.
  Must be a valid phone number ID that the requesting business owns or has sharing rights to.
   |

  ## `partner_business_id` Constraints

  - Pattern: `^[0-9]+$`

  ## `preverified_id` Constraints

  - Pattern: `^[0-9]+$`
  """

  @type t :: %__MODULE__{
          partner_business_id: String.t(),
          preverified_id: String.t()
        }
  @enforce_keys [:preverified_id, :partner_business_id]
  defstruct [
    :partner_business_id,
    :preverified_id
  ]
end
