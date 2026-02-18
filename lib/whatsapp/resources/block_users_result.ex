defmodule WhatsApp.Resources.BlockUsersResult do
  @moduledoc false

  @type t :: %__MODULE__{
          added_users: list(WhatsApp.Resources.BlockedUserOperation.t()) | nil
        }
  defstruct [
    :added_users
  ]
end
