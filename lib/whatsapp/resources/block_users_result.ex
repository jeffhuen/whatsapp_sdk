defmodule WhatsApp.Resources.BlockUsersResult do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `added_users` | `list()` |  |
  """

  @type t :: %__MODULE__{
          added_users: list(WhatsApp.Resources.BlockedUserOperation.t()) | nil
        }
  defstruct [
    :added_users
  ]
end
