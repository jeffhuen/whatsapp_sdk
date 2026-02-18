defmodule WhatsApp.Resources.WhatsAppBusinessProfileNode do
  @moduledoc """
  WhatsApp Business Profile node details and configuration

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `about` | `String.t()` | About section text for the business profile |
  | `account_name` | `String.t()` | Name of the business account |
  | `address` | `String.t()` | Physical address of the business |
  | `description` | `String.t()` | Business description text |
  | `email` | `String.t()` | Contact email address of the business |
  | `id` | `String.t()` | Unique identifier for the WhatsApp Business Profile |
  | `messaging_product` | `String.t()` | The messaging service used |
  | `profile_picture_handle` | `String.t()` | Handle of the profile picture for upload operations |
  | `profile_picture_url` | `String.t()` | URL of the business profile picture |
  | `vertical` | `String.t()` | The industry type of the business |
  | `websites` | `list()` | List of website URLs associated with the business |

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
          id: String.t(),
          messaging_product: String.t() | nil,
          profile_picture_handle: String.t() | nil,
          profile_picture_url: String.t() | nil,
          vertical: String.t() | nil,
          websites: list(String.t()) | nil
        }
  @enforce_keys [:id]
  defstruct [
    :about,
    :account_name,
    :address,
    :description,
    :email,
    :id,
    :messaging_product,
    :profile_picture_handle,
    :profile_picture_url,
    :vertical,
    :websites
  ]
end
