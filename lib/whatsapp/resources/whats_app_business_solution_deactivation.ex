defmodule WhatsApp.Resources.WhatsAppBusinessSolutionDeactivation do
  @moduledoc """
  Successful response for deactivation request submission
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
