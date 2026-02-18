defmodule WhatsApp.Resources.WhatsAppBusinessAccount3 do
  @moduledoc """
  WhatsApp Business Account details and configuration

  ## `account_review_status` Values
  | Value |
  | --- |
  | `PENDING` |
  | `APPROVED` |
  | `REJECTED` |
  | `LIMIT_REACHED` |

  ## `business_verification_status` Values
  | Value |
  | --- |
  | `VERIFIED` |
  | `UNVERIFIED` |
  | `PENDING` |

  ## `ownership_type` Values
  | Value |
  | --- |
  | `SELF_OWNED` |
  | `CLIENT_OWNED` |
  | `AGENCY_OWNED` |

  ## `name` Constraints

  - Minimum length: 1
  - Maximum length: 100
  """

  @type t :: %__MODULE__{
          account_review_status: String.t() | nil,
          business_verification_status: String.t() | nil,
          country: String.t() | nil,
          id: String.t(),
          message_template_namespace: String.t() | nil,
          name: String.t(),
          ownership_type: String.t() | nil,
          primary_business_location: String.t() | nil,
          timezone_id: String.t() | nil
        }
  @enforce_keys [:id, :name]
  defstruct [
    :account_review_status,
    :business_verification_status,
    :country,
    :id,
    :message_template_namespace,
    :name,
    :ownership_type,
    :primary_business_location,
    :timezone_id
  ]
end
