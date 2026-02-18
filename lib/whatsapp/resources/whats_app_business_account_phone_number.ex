defmodule WhatsApp.Resources.WhatsAppBusinessAccountPhoneNumber do
  @moduledoc """
  WhatsApp Business Account phone number details and status information

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

  ## `host_platform` Values
  | Value |
  | --- |
  | `CLOUD_API` |
  | `ON_PREMISE` |
  | `NOT_APPLICABLE` |

  ## `messaging_limit_tier` Values
  | Value |
  | --- |
  | `TIER_50` |
  | `TIER_250` |
  | `TIER_1K` |
  | `TIER_10K` |
  | `TIER_100K` |
  | `TIER_UNLIMITED` |

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
  | `PENDING` |
  | `LINKED` |
  | `UNLINKED` |
  | `DELETED` |
  | `MIGRATED` |
  | `BANNED` |
  | `RESTRICTED` |

  ## `unified_cert_status` Values
  | Value |
  | --- |
  | `APPROVED` |
  | `NAME_PENDING_REVIEW` |
  | `NAME_NOT_APPROVED` |
  | `ACCOUNT_REVIEW_NOT_STARTED` |
  | `LIMITED_ACCESS` |
  """

  @type t :: %__MODULE__{
          account_mode: String.t() | nil,
          code_verification_status: String.t() | nil,
          country_code: String.t() | nil,
          country_dial_code: String.t() | nil,
          display_phone_number: String.t(),
          host_platform: String.t() | nil,
          id: String.t(),
          is_official_business_account: boolean() | nil,
          messaging_limit_tier: String.t() | nil,
          quality_rating: String.t() | nil,
          status: String.t(),
          unified_cert_status: String.t() | nil,
          username: String.t() | nil,
          verified_name: String.t() | nil
        }
  @enforce_keys [:id, :display_phone_number, :status]
  defstruct [
    :account_mode,
    :code_verification_status,
    :country_code,
    :country_dial_code,
    :display_phone_number,
    :host_platform,
    :id,
    :is_official_business_account,
    :messaging_limit_tier,
    :quality_rating,
    :status,
    :unified_cert_status,
    :username,
    :verified_name
  ]
end
