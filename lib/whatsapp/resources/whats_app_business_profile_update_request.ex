defmodule WhatsApp.Resources.WhatsAppBusinessProfileUpdateRequest do
  @moduledoc """
  Request payload for updating WhatsApp Business Profile

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `about` | `String.t()` | The text to display in business profile's About section |
  | `address` | `String.t()` | The address of the business |
  | `description` | `String.t()` | Description of the business |
  | `email` | `String.t()` | The contact email address of the business |
  | `messaging_product` | `String.t()` | The messaging service used for the request |
  | `profile_picture_handle` | `String.t()` | The handle of the profile picture generated from Resumable Upload API |
  | `vertical` | `String.t()` | The industry type of the business |
  | `websites` | `list()` | URLs associated with the business |

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

  ## `address` Constraints

  - Maximum length: 256

  ## `description` Constraints

  - Maximum length: 256

  ## `email` Constraints

  - Maximum length: 128

  ## `websites` Constraints

  - Maximum items: 2
  """

  @type t :: %__MODULE__{
          about: String.t() | nil,
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
    :address,
    :description,
    :email,
    :messaging_product,
    :profile_picture_handle,
    :vertical,
    :websites
  ]
end
