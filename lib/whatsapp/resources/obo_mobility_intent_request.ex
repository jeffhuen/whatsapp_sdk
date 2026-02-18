defmodule WhatsApp.Resources.OBOMobilityIntentRequest do
  @moduledoc """
  Request payload for OBO mobility intent operations

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `intent_type` | `String.t()` | Type of mobility intent operation |
  | `metadata` | `map()` | Additional metadata for the mobility operation |
  | `mobility_reason` | `String.t()` | Reason for the mobility intent |
  | `scheduled_execution_time` | `DateTime.t()` | Scheduled time for mobility execution (ISO 8601 format) |
  | `solution_id` | `String.t()` | Unique identifier for the WhatsApp Business Solution |
  | `target_solution_id` | `String.t()` | Target solution ID for mobility operations (required for transfers) |

  ## `intent_type` Values
  | Value |
  | --- |
  | `INITIATE_TRANSFER` |
  | `CONFIRM_TRANSFER` |
  | `CANCEL_TRANSFER` |
  | `REQUEST_HANDOVER` |
  | `APPROVE_HANDOVER` |
  | `REJECT_HANDOVER` |

  ## `mobility_reason` Constraints

  - Maximum length: 500
  """

  @type t :: %__MODULE__{
          intent_type: String.t(),
          metadata: map() | nil,
          mobility_reason: String.t() | nil,
          scheduled_execution_time: DateTime.t() | nil,
          solution_id: String.t(),
          target_solution_id: String.t() | nil
        }
  @enforce_keys [:solution_id, :intent_type]
  defstruct [
    :intent_type,
    :metadata,
    :mobility_reason,
    :scheduled_execution_time,
    :solution_id,
    :target_solution_id
  ]
end
