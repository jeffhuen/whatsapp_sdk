defmodule WhatsApp.Resources.SetSolutionMigrationIntent do
  @moduledoc """
  Response for setting solution migration intent

  ## `status` Values
  | Value |
  | --- |
  | `PENDING` |
  | `APPROVED` |
  | `REJECTED` |
  | `SCHEDULED` |
  """

  @type t :: %__MODULE__{
          estimated_completion_time: DateTime.t() | nil,
          migration_intent_id: String.t(),
          status: String.t() | nil,
          success: boolean()
        }
  @enforce_keys [:success, :migration_intent_id]
  defstruct [
    :estimated_completion_time,
    :migration_intent_id,
    :status,
    :success
  ]
end
