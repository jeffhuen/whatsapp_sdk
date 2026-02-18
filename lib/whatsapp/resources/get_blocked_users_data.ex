defmodule WhatsApp.Resources.GetBlockedUsersData do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` |  |
  | `paging` | `map()` |  |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.BlockedUser.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
