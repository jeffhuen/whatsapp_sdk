defmodule WhatsApp.Resources.WhatsAppBusinessSolutionCreate do
  @moduledoc """
  Successful response containing the created solution identifier

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
