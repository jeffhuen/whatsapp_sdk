defmodule WhatsApp.Resources.OfficialBusinessAccountUpdate do
  @moduledoc """
  Response for Official Business Account status update operation

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `message` | `String.t()` | Human-readable message describing the result of the operation |
  | `success` | `boolean()` | Indicates if the operation was successful |
  | `tracking_id` | `String.t()` | Unique identifier for tracking the application/update request |
  | `updated_status` | `map()` | Official Business Account status information for a WhatsApp Business Account phone number |
  """

  @type t :: %__MODULE__{
          message: String.t(),
          success: boolean(),
          tracking_id: String.t() | nil,
          updated_status: map() | nil
        }
  @enforce_keys [:success, :message]
  defstruct [
    :message,
    :success,
    :tracking_id,
    :updated_status
  ]
end
