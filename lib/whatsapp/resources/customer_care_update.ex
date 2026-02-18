defmodule WhatsApp.Resources.CustomerCareUpdate do
  @moduledoc """
  Contact information for customer care and support

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `email` | `String.t()` | Email address for customer care contact |
  | `landline_number` | `String.t()` | Landline phone number for customer care (with country code) |
  | `mobile_number` | `String.t()` | Mobile phone number for customer care (with country code) |

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
