defmodule WhatsApp.Resources.UnblockUsersResult do
  @moduledoc false

  @type t :: %__MODULE__{
          removed_users: list(WhatsApp.Resources.BlockedUserOperation.t()) | nil
        }
  defstruct [
    :removed_users
  ]
end
