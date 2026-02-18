defmodule WhatsApp.Resources.GrievanceOfficerUpdate do
  @moduledoc """
  Contact information for the designated grievance officer

  ## `email` Constraints

  - Maximum length: 128

  ## `landline_number` Constraints

  - Maximum length: 20
  - Pattern: `^\\+[1-9]\\d{1,14}$`

  ## `mobile_number` Constraints

  - Maximum length: 20
  - Pattern: `^\\+[1-9]\\d{1,14}$`

  ## `name` Constraints

  - Maximum length: 128
  """

  @type t :: %__MODULE__{
          email: String.t(),
          landline_number: String.t() | nil,
          mobile_number: String.t() | nil,
          name: String.t()
        }
  @enforce_keys [:name, :email]
  defstruct [
    :email,
    :landline_number,
    :mobile_number,
    :name
  ]
end
