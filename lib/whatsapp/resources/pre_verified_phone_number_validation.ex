defmodule WhatsApp.Resources.PreVerifiedPhoneNumberValidation do
  @moduledoc """
  Pre-verified phone number validation details and status

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
