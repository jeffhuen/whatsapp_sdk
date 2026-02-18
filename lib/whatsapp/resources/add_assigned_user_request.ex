defmodule WhatsApp.Resources.AddAssignedUserRequest do
  @moduledoc """
  ## `tasks` Constraints

  - Minimum items: 1
  - Maximum items: 16

  ## `user` Constraints

  - Pattern: `^[0-9]+$`
  """

  @type t :: %__MODULE__{
          tasks: list(term()),
          user: String.t()
        }
  @enforce_keys [:user, :tasks]
  defstruct [
    :tasks,
    :user
  ]
end
