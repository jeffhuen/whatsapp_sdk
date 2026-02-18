defmodule WhatsApp.Resources.PreVerifiedPhoneNumber do
  @moduledoc """
  Pre-verified phone number details and status information

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `availability_status` | `String.t()` | Current availability status of the pre-verified phone number |
  | `country_code` | `String.t()` | ISO 3166-1 alpha-2 country code for the phone number |
  | `country_prefix` | `integer()` | Country code prefix for the phone number |
  | `created_time` | `DateTime.t()` | Timestamp when the phone number was pre-verified |
  | `display_phone_number` | `String.t()` | Formatted display version of the phone number |
  | `id` | `String.t()` | Unique identifier for the pre-verified phone number |
  | `last_updated` | `DateTime.t()` | Timestamp when the phone number information was last updated |
  | `region` | `String.t()` | Geographic region or area for the phone number |
  | `supported_features` | `list()` | List of WhatsApp Business features supported by this phone number |
  | `verification_status` | `String.t()` | Current verification status of the pre-verified phone number |

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
