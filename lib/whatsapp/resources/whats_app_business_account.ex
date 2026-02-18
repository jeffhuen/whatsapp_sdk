defmodule WhatsApp.Resources.WhatsAppBusinessAccount do
  @moduledoc """
  WhatsApp Business Account details and configuration

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `account_review_status` | `String.t()` | Review status of the WhatsApp Business Account |
  | `audiences` | `list()` | List of audience segments associated with the account |
  | `business_verification_status` | `String.t()` | Verification status of the connected client business |
  | `country` | `String.t()` | Country code where the WABA is registered |
  | `currency` | `String.t()` | Currency code for the WABA |
  | `dcc_config` | `map()` | Data and Content Control configuration |
  | `id` | `String.t()` | Unique identifier for the WhatsApp Business Account |
  | `is_enabled_for_insights` | `boolean()` | Whether insights are enabled for this WABA |
  | `message_templates` | `list()` | Message templates associated with the WABA |
  | `name` | `String.t()` | Human-readable name of the WhatsApp Business Account |
  | `on_behalf_of_business_info` | `map()` | Information about the business on whose behalf the WABA operates |
  | `ownership_type` | `String.t()` | Type of ownership for the WhatsApp Business Account |
  | `phone_numbers` | `list()` | Phone numbers associated with the WABA |
  | `purchase_order_number` | `String.t()` | Purchase order number associated with the account |
  | `schedules` | `list()` | Business hours and scheduling information |
  | `subscribed_apps` | `list()` | List of applications subscribed to this WABA |
  | `timezone_id` | `String.t()` | Timezone identifier for the WABA |

  ## `account_review_status` Values
  | Value |
  | --- |
  | `APPROVED` |
  | `PENDING` |
  | `REJECTED` |
  | `RESTRICTED` |

  ## `business_verification_status` Values
  | Value |
  | --- |
  | `VERIFIED` |
  | `UNVERIFIED` |
  | `PENDING` |
  | `REJECTED` |

  ## `ownership_type` Values
  | Value |
  | --- |
  | `SELF_OWNED` |
  | `CLIENT_OWNED` |
  | `AGENCY_OWNED` |

  ## `country` Constraints

  - Pattern: `^[A-Z]{2}$`

  ## `currency` Constraints

  - Pattern: `^[A-Z]{3}$`

  ## `name` Constraints

  - Minimum length: 1
  - Maximum length: 255
  """

  @type t :: %__MODULE__{
          account_review_status: String.t() | nil,
          audiences: list(String.t()) | nil,
          business_verification_status: String.t() | nil,
          country: String.t() | nil,
          currency: String.t() | nil,
          dcc_config: map() | nil,
          id: String.t(),
          is_enabled_for_insights: boolean() | nil,
          message_templates: list(WhatsApp.Resources.MessageTemplate.t()) | nil,
          name: String.t(),
          on_behalf_of_business_info: map() | nil,
          ownership_type: String.t() | nil,
          phone_numbers: list(WhatsApp.Resources.PhoneNumber.t()) | nil,
          purchase_order_number: String.t() | nil,
          schedules: list(WhatsApp.Resources.BusinessSchedule.t()) | nil,
          subscribed_apps: list(WhatsApp.Resources.SubscribedApp.t()) | nil,
          timezone_id: String.t() | nil
        }
  @enforce_keys [:id, :name]
  defstruct [
    :account_review_status,
    :audiences,
    :business_verification_status,
    :country,
    :currency,
    :dcc_config,
    :id,
    :is_enabled_for_insights,
    :message_templates,
    :name,
    :on_behalf_of_business_info,
    :ownership_type,
    :phone_numbers,
    :purchase_order_number,
    :schedules,
    :subscribed_apps,
    :timezone_id
  ]
end
