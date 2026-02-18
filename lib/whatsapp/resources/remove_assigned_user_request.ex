defmodule WhatsApp.Resources.RemoveAssignedUserRequest do
  @moduledoc """
  ## `user` Constraints

  - Pattern: `^[0-9]+$`
  """

  @type t :: %__MODULE__{
          user: String.t()
        }
  @enforce_keys [:user]
  defstruct [
    :user
  ]
end
