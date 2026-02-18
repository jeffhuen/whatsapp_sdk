defmodule WhatsApp.Resources.WhatsAppBusinessAccount do
  @moduledoc """
  WhatsApp Business Account details and configuration

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
