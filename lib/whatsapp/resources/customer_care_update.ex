defmodule WhatsApp.Resources.CustomerCareUpdate do
  @moduledoc """
  Contact information for customer care and support

  ## `email` Constraints

  - Maximum length: 128

  ## `landline_number` Constraints

  - Maximum length: 20
  - Pattern: `^\\+[1-9]\\d{1,14}$`

  ## `mobile_number` Constraints

  - Maximum length: 20
  - Pattern: `^\\+[1-9]\\d{1,14}$`
  """

  @type t :: %__MODULE__{
          email: String.t(),
          landline_number: String.t() | nil,
          mobile_number: String.t() | nil
        }
  @enforce_keys [:email]
  defstruct [
    :email,
    :landline_number,
    :mobile_number
  ]
end
