defmodule WhatsApp.Resources.Statuses do
  @moduledoc """
  ## `status` Values
  | Value |
  | --- |
  | `sent` |
  | `delivered` |
  | `read` |
  | `failed` |
  """

  @type t :: %__MODULE__{
          conversation: map() | nil,
          errors: list(WhatsApp.Resources.StatusError.t()) | nil,
          group_id: String.t() | nil,
          id: String.t(),
          pricing: map() | nil,
          recipient_id: String.t(),
          status: String.t(),
          timestamp: String.t()
        }
  @enforce_keys [:id, :status, :timestamp, :recipient_id]
  defstruct [
    :conversation,
    :errors,
    :group_id,
    :id,
    :pricing,
    :recipient_id,
    :status,
    :timestamp
  ]
end
