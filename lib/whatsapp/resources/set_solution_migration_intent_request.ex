defmodule WhatsApp.Resources.SetSolutionMigrationIntentRequest do
  @moduledoc """
  Request payload for setting solution migration intent

  ## `migration_intent` Values
  | Value |
  | --- |
  | `INITIATE_MIGRATION` |
  | `CANCEL_MIGRATION` |
  | `CONFIRM_MIGRATION` |
  | `SCHEDULE_MIGRATION` |

  ## `migration_reason` Constraints

  - Maximum length: 500

  ## `solution_id` Constraints

  - Pattern: `^[0-9]+$`

  ## `target_solution_id` Constraints

  - Pattern: `^[0-9]+$`
  """

  @type t :: %__MODULE__{
          migration_intent: String.t(),
          migration_reason: String.t() | nil,
          scheduled_migration_time: DateTime.t() | nil,
          solution_id: String.t(),
          target_solution_id: String.t() | nil
        }
  @enforce_keys [:solution_id, :migration_intent]
  defstruct [
    :migration_intent,
    :migration_reason,
    :scheduled_migration_time,
    :solution_id,
    :target_solution_id
  ]
end
