defmodule WhatsApp.Resources.SharedPreVerifiedPhoneNumber do
  @moduledoc """
  Details of the shared pre-verified phone number

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `country_prefix` | `integer()` | Country code prefix for the phone number |
  | `display_phone_number` | `String.t()` | Formatted display version of the phone number |
  | `id` | `String.t()` | Unique identifier for the pre-verified phone number |
  | `verification_status` | `String.t()` | Current verification status of the phone number |

  ## `verification_status` Values
  | Value |
  | --- |
  | `VERIFIED` |
  | `PENDING` |
  | `FAILED` |

  ## `country_prefix` Constraints

  - Minimum value: 1
  - Maximum value: 999
  """

  @type t :: %__MODULE__{
          country_prefix: integer() | nil,
          display_phone_number: String.t() | nil,
          id: String.t() | nil,
          verification_status: String.t() | nil
        }
  defstruct [
    :country_prefix,
    :display_phone_number,
    :id,
    :verification_status
  ]
end
