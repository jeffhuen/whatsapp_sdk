defmodule WhatsApp.Resources.WhatsAppBusinessMessageDeliveryStatusOccurrence do
  @moduledoc """
  Message delivery status occurrence with detailed event information

  ## `delivery_status` Values
  | Value |
  | --- |
  | `SENT` |
  | `DELIVERED` |
  | `READ` |
  | `FAILED` |
  | `DELETED` |
  """

  @type t :: %__MODULE__{
          application: map() | nil,
          delivery_status: String.t(),
          error_description: String.t() | nil,
          id: String.t(),
          occurrence_timestamp: integer(),
          status_timestamp: integer() | nil
        }
  @enforce_keys [:id, :delivery_status, :occurrence_timestamp]
  defstruct [
    :application,
    :delivery_status,
    :error_description,
    :id,
    :occurrence_timestamp,
    :status_timestamp
  ]
end
