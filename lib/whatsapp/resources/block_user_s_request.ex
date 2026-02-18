defmodule WhatsApp.Resources.BlockUserSRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `block_users` | `list()` |  |
  | `messaging_product` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          block_users: list(map()) | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :block_users,
    :messaging_product
  ]
end
