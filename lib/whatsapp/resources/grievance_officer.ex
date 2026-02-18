defmodule WhatsApp.Resources.GrievanceOfficer do
  @moduledoc """
  Contact information for the designated grievance officer

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `email` | `String.t()` | Email address for grievance officer contact |
  | `landline_number` | `String.t()` | Landline phone number for grievance officer (with country code) |
  | `mobile_number` | `String.t()` | Mobile phone number for grievance officer (with country code) |
  | `name` | `String.t()` | Full name of the grievance officer |

  ## `landline_number` Constraints

  - Pattern: `^\\+[1-9]\\d{1,14}$`

  ## `mobile_number` Constraints

  - Pattern: `^\\+[1-9]\\d{1,14}$`
  """

  @type t :: %__MODULE__{
          email: String.t() | nil,
          landline_number: String.t() | nil,
          mobile_number: String.t() | nil,
          name: String.t() | nil
        }
  defstruct [
    :email,
    :landline_number,
    :mobile_number,
    :name
  ]
end
