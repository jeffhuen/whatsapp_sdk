defmodule WhatsApp.Resources.SetSolutionMigrationIntent do
  @moduledoc """
  Response for setting solution migration intent

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `estimated_completion_time` | `DateTime.t()` | Estimated completion time for the migration (ISO 8601 format) |
  | `migration_intent_id` | `String.t()` | Unique identifier for the migration intent request |
  | `status` | `String.t()` | Current status of the migration intent |
  | `success` | `boolean()` | Indicates if the migration intent was set successfully |

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
