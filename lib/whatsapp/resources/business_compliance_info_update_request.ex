defmodule WhatsApp.Resources.BusinessComplianceInfoUpdateRequest do
  @moduledoc """
  Request object for updating WhatsApp Business Account compliance information

  ## `entity_type` Values
  | Value |
  | --- |
  | `LIMITED_LIABILITY_PARTNERSHIP` |
  | `SOLE_PROPRIETORSHIP` |
  | `PARTNERSHIP` |
  | `PUBLIC_COMPANY` |
  | `PRIVATE_COMPANY` |
  | `OTHER` |

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |

  ## `entity_name` Constraints

  - Minimum length: 2
  - Maximum length: 128

  ## `entity_type_custom` Constraints

  - Maximum length: 1024
  """

  @type t :: %__MODULE__{
          customer_care_details: map(),
          entity_name: String.t(),
          entity_type: String.t(),
          entity_type_custom: String.t() | nil,
          grievance_officer_details: map(),
          is_registered: boolean() | nil,
          messaging_product: String.t()
        }
  @enforce_keys [
    :messaging_product,
    :entity_name,
    :entity_type,
    :grievance_officer_details,
    :customer_care_details
  ]
  defstruct [
    :customer_care_details,
    :entity_name,
    :entity_type,
    :entity_type_custom,
    :grievance_officer_details,
    :is_registered,
    :messaging_product
  ]
end
