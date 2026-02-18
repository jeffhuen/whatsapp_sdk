defmodule WhatsApp.Resources.BusinessComplianceInfo do
  @moduledoc """
  WhatsApp Business Account compliance information and regulatory details

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `customer_care_details` | `map()` | Contact information for customer care and support |
  | `entity_name` | `String.t()` | Legal name of the business entity |
  | `entity_type` | `String.t()` | Type of business entity (e.g., Partnership, Private Limited Company, etc.) |
  | `entity_type_custom` | `String.t()` | Custom entity type description when standard types don't apply |
  | `grievance_officer_details` | `map()` | Contact information for the designated grievance officer |
  | `is_registered` | `boolean()` | Whether the business entity is officially registered with regulatory authorities |
  | `messaging_product` | `String.t()` | Messaging product identifier, always 'whatsapp' for WhatsApp Business |
  | `whatsapp_business_account_id` | `String.t()` | Unique identifier for the WhatsApp Business Account |

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |
  """

  @type t :: %__MODULE__{
          customer_care_details: map() | nil,
          entity_name: String.t() | nil,
          entity_type: String.t() | nil,
          entity_type_custom: String.t() | nil,
          grievance_officer_details: map() | nil,
          is_registered: boolean() | nil,
          messaging_product: String.t() | nil,
          whatsapp_business_account_id: String.t()
        }
  @enforce_keys [:whatsapp_business_account_id]
  defstruct [
    :customer_care_details,
    :entity_name,
    :entity_type,
    :entity_type_custom,
    :grievance_officer_details,
    :is_registered,
    :messaging_product,
    :whatsapp_business_account_id
  ]
end
