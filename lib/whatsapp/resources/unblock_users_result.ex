defmodule WhatsApp.Resources.UnblockUsersResult do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `removed_users` | `list()` |  |
  """

  @type t :: %__MODULE__{
          removed_users: list(WhatsApp.Resources.BlockedUserOperation.t()) | nil
        }
  defstruct [
    :removed_users
  ]
end
