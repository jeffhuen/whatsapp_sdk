defmodule WhatsApp.Resources.WhatsAppBusinessSolutionCreate do
  @moduledoc """
  Successful response containing the created solution identifier

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `solution_id` | `String.t()` | Unique identifier for the newly created Multi-Partner Solution.
  Use this ID for subsequent solution management operations.
   |

  ## `solution_id` Constraints

  - Pattern: `^[0-9]+$`
  """

  @type t :: %__MODULE__{
          solution_id: String.t()
        }
  @enforce_keys [:solution_id]
  defstruct [
    :solution_id
  ]
end
