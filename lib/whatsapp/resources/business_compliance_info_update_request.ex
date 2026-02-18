defmodule WhatsApp.Resources.BusinessComplianceInfoUpdateRequest do
  @moduledoc """
  Request object for updating WhatsApp Business Account compliance information

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `customer_care_details` | `map()` | Contact information for customer care and support |
  | `entity_name` | `String.t()` | Legal name of the business entity |
  | `entity_type` | `String.t()` | Type of business entity for compliance purposes |
  | `entity_type_custom` | `String.t()` | Custom entity type description when entity_type is "OTHER". Required for OTHER entity type. |
  | `grievance_officer_details` | `map()` | Contact information for the designated grievance officer |
  | `is_registered` | `boolean()` | Whether the business entity is officially registered with regulatory authorities. Can only be used with "OTHER" or "PARTNERSHIP" entity types. |
  | `messaging_product` | `String.t()` | Messaging product identifier, must be 'whatsapp' |

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
