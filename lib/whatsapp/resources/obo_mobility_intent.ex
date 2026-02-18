defmodule WhatsApp.Resources.OBOMobilityIntent do
  @moduledoc """
  Response for OBO mobility intent operations

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `approval_required` | `boolean()` | Indicates if additional approval is required for the operation |
  | `estimated_completion_time` | `DateTime.t()` | Estimated completion time for the mobility operation (ISO 8601 format) |
  | `mobility_intent_id` | `String.t()` | Unique identifier for the mobility intent request |
  | `next_steps` | `list()` | List of next steps required to complete the mobility operation |
  | `status` | `String.t()` | Current status of the mobility intent |
  | `success` | `boolean()` | Indicates if the mobility intent operation was successful |

  ## `status` Values
  | Value |
  | --- |
  | `PENDING` |
  | `APPROVED` |
  | `REJECTED` |
  | `SCHEDULED` |
  | `IN_PROGRESS` |
  | `COMPLETED` |
  | `FAILED` |
  """

  @type t :: %__MODULE__{
          approval_required: boolean() | nil,
          estimated_completion_time: DateTime.t() | nil,
          mobility_intent_id: String.t(),
          next_steps: list(String.t()) | nil,
          status: String.t() | nil,
          success: boolean()
        }
  @enforce_keys [:success, :mobility_intent_id]
  defstruct [
    :approval_required,
    :estimated_completion_time,
    :mobility_intent_id,
    :next_steps,
    :status,
    :success
  ]
end
