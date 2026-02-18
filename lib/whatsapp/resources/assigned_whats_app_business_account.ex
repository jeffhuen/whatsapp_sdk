defmodule WhatsApp.Resources.AssignedWhatsAppBusinessAccount do
  @moduledoc """
  WhatsApp Business Account assigned to a user

  ## `status` Values
  | Value |
  | --- |
  | `ACTIVE` |
  | `PENDING` |
  | `RESTRICTED` |
  | `DISABLED` |

  ## `name` Constraints

  - Minimum length: 1
  - Maximum length: 100
  """

  @type t :: %__MODULE__{
          assignment_date: DateTime.t() | nil,
          business_id: String.t() | nil,
          id: String.t(),
          name: String.t(),
          permissions: list(term()) | nil,
          phone_numbers: list(WhatsApp.Resources.PhoneNumberInfo.t()) | nil,
          status: String.t()
        }
  @enforce_keys [:id, :name, :status]
  defstruct [
    :assignment_date,
    :business_id,
    :id,
    :name,
    :permissions,
    :phone_numbers,
    :status
  ]
end
