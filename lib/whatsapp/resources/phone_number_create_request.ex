defmodule WhatsApp.Resources.PhoneNumberCreateRequest do
  @moduledoc """
  Request payload for creating a new phone number registration

  ## `cc` Constraints

  - Pattern: `^[0-9]{1,3}$`

  ## `phone_number` Constraints

  - Pattern: `^[1-9][0-9]{6,14}$`

  ## `verified_name` Constraints

  - Minimum length: 2
  - Maximum length: 75
  """

  @type t :: %__MODULE__{
          cc: String.t() | nil,
          migrate_phone_number: boolean() | nil,
          phone_number: String.t(),
          preverified_id: String.t() | nil,
          verified_name: String.t()
        }
  @enforce_keys [:phone_number, :verified_name]
  defstruct [
    :cc,
    :phone_number,
    :preverified_id,
    :verified_name,
    migrate_phone_number: false
  ]
end
