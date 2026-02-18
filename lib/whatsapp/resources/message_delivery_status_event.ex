defmodule WhatsApp.Resources.MessageDeliveryStatusEvent do
  @moduledoc """
  Message delivery status event occurrence

  ## `delivery_status` Values
  | Value |
  | --- |
  | `SENT` |
  | `DELIVERED` |
  | `READ` |
  | `FAILED` |
  | `DELETED` |

  ## `webhook_update_state` Values
  | Value |
  | --- |
  | `PENDING` |
  | `DELIVERED` |
  | `FAILED` |
  | `RETRYING` |
  """

  @type t :: %__MODULE__{
          application: map() | nil,
          delivery_status: String.t(),
          error_description: String.t() | nil,
          id: String.t(),
          timestamp: integer(),
          webhook_update_state: String.t() | nil,
          webhook_uri: String.t() | nil
        }
  @enforce_keys [:id, :delivery_status, :timestamp]
  defstruct [
    :application,
    :delivery_status,
    :error_description,
    :id,
    :timestamp,
    :webhook_update_state,
    :webhook_uri
  ]
end
