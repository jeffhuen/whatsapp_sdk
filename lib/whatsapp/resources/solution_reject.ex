defmodule WhatsApp.Resources.SolutionReject do
  @moduledoc """
  Successful response for solution rejection operation

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `partner_app_id` | `String.t()` | App ID of the partner whose request was rejected (for partnership rejections) |
  | `rejected_request_type` | `String.t()` | Type of request that was rejected |
  | `rejection_timestamp` | `DateTime.t()` | ISO 8601 timestamp when the rejection was processed |
  | `solution_id` | `String.t()` | The ID of the Multi-Partner Solution |
  | `success` | `boolean()` | Indicates whether the rejection was successful |

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
