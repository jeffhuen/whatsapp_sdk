defmodule WhatsApp.Resources.CustomerCare do
  @moduledoc """
  Contact information for customer care and support

  ## `landline_number` Constraints

  - Pattern: `^\\+[1-9]\\d{1,14}$`

  ## `mobile_number` Constraints

  - Pattern: `^\\+[1-9]\\d{1,14}$`
  """

  @type t :: %__MODULE__{
          email: String.t() | nil,
          landline_number: String.t() | nil,
          mobile_number: String.t() | nil
        }
  defstruct [
    :email,
    :landline_number,
    :mobile_number
  ]
end
