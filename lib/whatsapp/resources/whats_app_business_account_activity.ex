defmodule WhatsApp.Resources.WhatsAppBusinessAccountActivity do
  @moduledoc """
  WhatsApp Business Account activity record

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
