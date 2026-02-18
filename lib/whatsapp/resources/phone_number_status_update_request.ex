defmodule WhatsApp.Resources.PhoneNumberStatusUpdateRequest do
  @moduledoc """
  Request to update phone number status and configuration

  ## `connection_status` Values
  | Value |
  | --- |
  | `CONNECTED` |
  | `DISCONNECTED` |
  | `PENDING` |
  | `FLAGGED` |
  | `RESTRICTED` |
  | `RATE_LIMITED` |
  | `MESSAGING_LIMIT_TIER_0` |
  | `MESSAGING_LIMIT_TIER_1` |
  | `MESSAGING_LIMIT_TIER_2` |
  | `MESSAGING_LIMIT_TIER_3` |
  | `MESSAGING_LIMIT_TIER_4` |

  ## `search_visibility` Values
  | Value |
  | --- |
  | `VISIBLE` |
  | `HIDDEN` |

  ## `new_display_name` Constraints

  - Minimum length: 2
  - Maximum length: 75
  """

  @type t :: %__MODULE__{
          connection_status: String.t() | nil,
          new_display_name: String.t() | nil,
          pin: String.t() | nil,
          search_visibility: String.t() | nil,
          username: String.t() | nil,
          webhook_configuration: map() | nil,
          webhook_url: String.t() | nil,
          whatsapp_business_api_data: map() | nil
        }
  defstruct [
    :connection_status,
    :new_display_name,
    :pin,
    :search_visibility,
    :username,
    :webhook_configuration,
    :webhook_url,
    :whatsapp_business_api_data
  ]
end
