defmodule WhatsApp.Resources.BusinessComplianceInfo do
  @moduledoc """
  WhatsApp Business Account compliance information and regulatory details

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
