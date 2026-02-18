defmodule WhatsApp.Resources.WhatsAppAccountNumber do
  @moduledoc """
  WhatsApp Account Number details and configuration

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `account_mode` | `String.t()` | Account mode indicating sandbox or live environment |
  | `certificate` | `String.t()` | Business certificate information for the account number |
  | `code_verification_status` | `String.t()` | Two-step verification status for the phone number |
  | `country_code` | `String.t()` | ISO 3166-1 alpha-2 country code |
  | `country_dial_code` | `String.t()` | Country dialing code |
  | `display_phone_number` | `String.t()` | Phone number in international format for display purposes |
  | `id` | `String.t()` | Unique identifier for the WhatsApp Account Number |
  | `is_official_business_account` | `boolean()` | Whether this is an official business account |
  | `messaging_limit_tier` | `String.t()` | Current messaging limit tier for the account number |
  | `name_status` | `String.t()` | Status of the display name associated with the phone number |
  | `quality_rating` | `String.t()` | Quality rating based on message delivery and user feedback |
  | `status` | `String.t()` | Current status of the WhatsApp Account Number |
  | `verified_name` | `String.t()` | Business name verified for this phone number |

  ## `account_mode` Values
  | Value |
  | --- |
  | `LIVE` |
  | `SANDBOX` |

  ## `code_verification_status` Values
  | Value |
  | --- |
  | `VERIFIED` |
  | `UNVERIFIED` |

  ## `messaging_limit_tier` Values
  | Value |
  | --- |
  | `TIER_50` |
  | `TIER_250` |
  | `TIER_1K` |
  | `TIER_10K` |
  | `TIER_100K` |
  | `TIER_UNLIMITED` |

  ## `name_status` Values
  | Value |
  | --- |
  | `APPROVED` |
  | `AVAILABLE_WITHOUT_REVIEW` |
  | `DECLINED` |
  | `EXPIRED` |
  | `PENDING_REVIEW` |
  | `NONE` |

  ## `quality_rating` Values
  | Value |
  | --- |
  | `GREEN` |
  | `YELLOW` |
  | `RED` |
  | `NA` |

  ## `status` Values
  | Value |
  | --- |
  | `CONNECTED` |
  | `DISCONNECTED` |
  | `UNVERIFIED` |
  | `PENDING` |
  | `FLAGGED` |
  | `RESTRICTED` |
  """

  @type t :: %__MODULE__{
          account_mode: String.t() | nil,
          certificate: String.t() | nil,
          code_verification_status: String.t() | nil,
          country_code: String.t() | nil,
          country_dial_code: String.t() | nil,
          display_phone_number: String.t(),
          id: String.t(),
          is_official_business_account: boolean() | nil,
          messaging_limit_tier: String.t() | nil,
          name_status: String.t() | nil,
          quality_rating: String.t() | nil,
          status: String.t(),
          verified_name: String.t() | nil
        }
  @enforce_keys [:id, :display_phone_number, :status]
  defstruct [
    :account_mode,
    :certificate,
    :code_verification_status,
    :country_code,
    :country_dial_code,
    :display_phone_number,
    :id,
    :is_official_business_account,
    :messaging_limit_tier,
    :name_status,
    :quality_rating,
    :status,
    :verified_name
  ]
end
