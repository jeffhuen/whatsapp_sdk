defmodule WhatsApp.Resources.WhatsAppBusinessSolutionDeactivation do
  @moduledoc """
  Successful response for deactivation request submission

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `message` | `String.t()` | Human-readable message describing the result |
  | `request_id` | `String.t()` | Unique identifier for tracking the deactivation request |
  | `success` | `boolean()` | Indicates whether the deactivation request was successfully submitted |
  """

  @type t :: %__MODULE__{
          message: String.t(),
          request_id: String.t() | nil,
          success: boolean()
        }
  @enforce_keys [:success, :message]
  defstruct [
    :message,
    :request_id,
    :success
  ]
end
