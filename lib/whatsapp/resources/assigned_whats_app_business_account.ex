defmodule WhatsApp.Resources.AssignedWhatsAppBusinessAccount do
  @moduledoc """
  WhatsApp Business Account assigned to a user

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `assignment_date` | `DateTime.t()` | Date and time when the account was assigned to the user |
  | `business_id` | `String.t()` | Business ID that owns this WhatsApp Business Account |
  | `id` | `String.t()` | Unique identifier for the WhatsApp Business Account |
  | `name` | `String.t()` | Display name of the WhatsApp Business Account |
  | `permissions` | `list()` | List of permissions granted to the user for this account |
  | `phone_numbers` | `list()` | Phone numbers associated with this WhatsApp Business Account |
  | `status` | `String.t()` | Current status of the WhatsApp Business Account |

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
