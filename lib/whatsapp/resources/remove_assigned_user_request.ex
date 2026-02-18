defmodule WhatsApp.Resources.RemoveAssignedUserRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `user` | `String.t()` | User ID of the person to remove from the WhatsApp Business Account.
  This must be a valid Facebook user ID that is currently assigned to the account.
   |

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
