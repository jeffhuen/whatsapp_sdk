defmodule WhatsApp.Resources.PreVerifiedPhoneNumberValidation do
  @moduledoc """
  Pre-verified phone number validation details and status

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `country_prefix` | `integer()` | Country code prefix for the phone number |
  | `display_phone_number` | `String.t()` | Formatted display version of the phone number |
  | `error_msg` | `String.t()` | Error message if validation failed |
  | `id` | `String.t()` | Unique identifier for the pre-verified phone number |
  | `is_input_id_valid` | `boolean()` | Whether the provided phone number ID is valid |

  ## `country_prefix` Constraints

  - Minimum value: 1
  - Maximum value: 999
  """

  @type t :: %__MODULE__{
          country_prefix: integer() | nil,
          display_phone_number: String.t() | nil,
          error_msg: String.t() | nil,
          id: String.t() | nil,
          is_input_id_valid: boolean()
        }
  @enforce_keys [:is_input_id_valid]
  defstruct [
    :country_prefix,
    :display_phone_number,
    :error_msg,
    :id,
    :is_input_id_valid
  ]
end
