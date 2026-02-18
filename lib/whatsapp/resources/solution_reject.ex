defmodule WhatsApp.Resources.SolutionReject do
  @moduledoc """
  Successful response for solution rejection operation

  ## `rejected_request_type` Values
  | Value |
  | --- |
  | `PARTNERSHIP_REQUEST` |
  | `DEACTIVATION_REQUEST` |
  """

  @type t :: %__MODULE__{
          partner_app_id: String.t() | nil,
          rejected_request_type: String.t(),
          rejection_timestamp: DateTime.t() | nil,
          solution_id: String.t(),
          success: boolean()
        }
  @enforce_keys [:success, :solution_id, :rejected_request_type]
  defstruct [
    :partner_app_id,
    :rejected_request_type,
    :rejection_timestamp,
    :solution_id,
    :success
  ]
end
