defmodule WhatsApp.Resources.OBOMobilityIntent do
  @moduledoc """
  Response for OBO mobility intent operations

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
