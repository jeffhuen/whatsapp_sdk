defmodule WhatsApp.Resources.PhoneNumberStatusUpdateRequest do
  @moduledoc """
  Request to update phone number status and configuration

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `connection_status` | `String.t()` | Connection status between WhatsApp Business Account and phone number |
  | `new_display_name` | `String.t()` | New display name for name verification request |
  | `pin` | `String.t()` | Two-step verification PIN (can be empty string) |
  | `search_visibility` | `String.t()` | Search visibility status for the WhatsApp Business Account |
  | `username` | `String.t()` | Username for the WhatsApp Business Account |
  | `webhook_configuration` | `map()` | Webhook configuration settings |
  | `webhook_url` | `String.t()` | Webhook URL for receiving message notifications |
  | `whatsapp_business_api_data` | `map()` | WhatsApp Business API configuration data |

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
