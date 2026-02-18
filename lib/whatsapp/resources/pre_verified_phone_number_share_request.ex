defmodule WhatsApp.Resources.PreVerifiedPhoneNumberShareRequest do
  @moduledoc """
  Request payload for sharing a pre-verified phone number with another business

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
