defmodule WhatsApp.Resources.UnblockUsersData do
  @moduledoc false

  @type t :: %__MODULE__{
          block_users: map() | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :block_users,
    :messaging_product
  ]
end
