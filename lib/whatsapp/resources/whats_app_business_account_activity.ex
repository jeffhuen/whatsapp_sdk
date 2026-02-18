defmodule WhatsApp.Resources.WhatsAppBusinessAccountActivity do
  @moduledoc """
  WhatsApp Business Account activity record

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `activity_type` | `String.t()` | Type of activity performed on the WhatsApp Business Account |
  | `actor_id` | `String.t()` | ID of the user or system that performed the activity |
  | `actor_name` | `String.t()` | Name of the user or system that performed the activity |
  | `actor_type` | `String.t()` | Type of entity that performed the activity |
  | `description` | `String.t()` | Human-readable description of the activity |
  | `details` | `map()` | Additional structured details about the activity |
  | `id` | `String.t()` | Unique identifier for the activity record |
  | `ip_address` | `String.t()` | IP address from which the activity was performed (when available) |
  | `timestamp` | `DateTime.t()` | ISO 8601 timestamp when the activity occurred |
  | `user_agent` | `String.t()` | User agent string from the client that performed the activity |

  ## `activity_type` Values
  | Value |
  | --- |
  | `ACCOUNT_CREATED` |
  | `ACCOUNT_UPDATED` |
  | `ACCOUNT_DELETED` |
  | `PHONE_NUMBER_ADDED` |
  | `PHONE_NUMBER_REMOVED` |
  | `PHONE_NUMBER_VERIFIED` |
  | `USER_ADDED` |
  | `USER_REMOVED` |
  | `USER_ROLE_CHANGED` |
  | `PERMISSION_GRANTED` |
  | `PERMISSION_REVOKED` |
  | `TEMPLATE_CREATED` |
  | `TEMPLATE_UPDATED` |
  | `TEMPLATE_DELETED` |
  | `WEBHOOK_CONFIGURED` |
  | `API_ACCESS_GRANTED` |
  | `API_ACCESS_REVOKED` |
  | `BILLING_UPDATED` |
  | `COMPLIANCE_ACTION` |
  | `SECURITY_EVENT` |

  ## `actor_type` Values
  | Value |
  | --- |
  | `USER` |
  | `SYSTEM` |
  | `API` |
  | `ADMIN` |
  | `AUTOMATED_PROCESS` |
  """

  @type t :: %__MODULE__{
          activity_type: String.t(),
          actor_id: String.t() | nil,
          actor_name: String.t() | nil,
          actor_type: String.t(),
          description: String.t() | nil,
          details: map() | nil,
          id: String.t(),
          ip_address: String.t() | nil,
          timestamp: DateTime.t(),
          user_agent: String.t() | nil
        }
  @enforce_keys [:id, :activity_type, :timestamp, :actor_type]
  defstruct [
    :activity_type,
    :actor_id,
    :actor_name,
    :actor_type,
    :description,
    :details,
    :id,
    :ip_address,
    :timestamp,
    :user_agent
  ]
end
