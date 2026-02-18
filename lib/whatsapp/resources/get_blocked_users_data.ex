defmodule WhatsApp.Resources.GetBlockedUsersData do
  @moduledoc false

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.BlockedUser.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
