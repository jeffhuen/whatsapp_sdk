defmodule WhatsApp.Resources.OBOMobilityIntentRequest do
  @moduledoc """
  Request payload for OBO mobility intent operations

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
