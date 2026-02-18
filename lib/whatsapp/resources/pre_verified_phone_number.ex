defmodule WhatsApp.Resources.PreVerifiedPhoneNumber do
  @moduledoc """
  Pre-verified phone number details and status information

  ## `availability_status` Values
  | Value |
  | --- |
  | `AVAILABLE` |
  | `IN_USE` |
  | `RESERVED` |
  | `UNAVAILABLE` |

  ## `verification_status` Values
  | Value |
  | --- |
  | `VERIFIED` |
  | `PENDING` |
  | `FAILED` |
  | `EXPIRED` |

  ## `country_code` Constraints

  - Pattern: `^[A-Z]{2}$`

  ## `country_prefix` Constraints

  - Minimum value: 1
  - Maximum value: 999
  """

  @type t :: %__MODULE__{
          availability_status: String.t() | nil,
          country_code: String.t() | nil,
          country_prefix: integer() | nil,
          created_time: DateTime.t() | nil,
          display_phone_number: String.t(),
          id: String.t(),
          last_updated: DateTime.t() | nil,
          region: String.t() | nil,
          supported_features: list(term()) | nil,
          verification_status: String.t()
        }
  @enforce_keys [:id, :display_phone_number, :verification_status]
  defstruct [
    :availability_status,
    :country_code,
    :country_prefix,
    :created_time,
    :display_phone_number,
    :id,
    :last_updated,
    :region,
    :supported_features,
    :verification_status
  ]
end
