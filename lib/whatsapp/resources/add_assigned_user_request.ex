defmodule WhatsApp.Resources.AddAssignedUserRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `tasks` | `list()` | Array of permission tasks to grant to the user. These tasks determine
  what actions the user can perform on the WhatsApp Business Account.
   |
  | `user` | `String.t()` | User ID of the person to add to the WhatsApp Business Account.
  This must be a valid Facebook user ID.
   |

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
