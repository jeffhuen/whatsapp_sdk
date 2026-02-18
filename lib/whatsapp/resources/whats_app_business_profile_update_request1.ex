defmodule WhatsApp.Resources.WhatsAppBusinessProfileUpdateRequest1 do
  @moduledoc """
  Request payload for updating WhatsApp Business Profile information

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |

  ## `vertical` Values
  | Value |
  | --- |
  | `OTHER` |
  | `AUTO` |
  | `BEAUTY` |
  | `APPAREL` |
  | `EDU` |
  | `ENTERTAIN` |
  | `EVENT_PLAN` |
  | `FINANCE` |
  | `GROCERY` |
  | `GOVT` |
  | `HOTEL` |
  | `HEALTH` |
  | `NONPROFIT` |
  | `PROF_SERVICES` |
  | `RETAIL` |
  | `TRAVEL` |
  | `RESTAURANT` |
  | `ALCOHOL` |
  | `ONLINE_GAMBLING` |
  | `PHYSICAL_GAMBLING` |
  | `OTC_DRUGS` |

  ## `about` Constraints

  - Minimum length: 1
  - Maximum length: 139

  ## `account_name` Constraints

  - Minimum length: 1
  - Maximum length: 75

  ## `address` Constraints

  - Maximum length: 256

  ## `description` Constraints

  - Minimum length: 1
  - Maximum length: 256

  ## `email` Constraints

  - Maximum length: 128

  ## `websites` Constraints

  - Maximum items: 2
  """

  @type t :: %__MODULE__{
          about: String.t() | nil,
          account_name: String.t() | nil,
          address: String.t() | nil,
          description: String.t() | nil,
          email: String.t() | nil,
          messaging_product: String.t(),
          profile_picture_handle: String.t() | nil,
          vertical: String.t() | nil,
          websites: list(String.t()) | nil
        }
  @enforce_keys [:messaging_product]
  defstruct [
    :about,
    :account_name,
    :address,
    :description,
    :email,
    :messaging_product,
    :profile_picture_handle,
    :vertical,
    :websites
  ]
end
