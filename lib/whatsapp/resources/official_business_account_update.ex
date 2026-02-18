defmodule WhatsApp.Resources.OfficialBusinessAccountUpdate do
  @moduledoc """
  Response for Official Business Account status update operation
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
