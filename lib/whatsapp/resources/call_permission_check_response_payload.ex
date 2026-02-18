defmodule WhatsApp.Resources.CallPermissionCheckResponsePayload do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `actions` | `list()` | Available actions and their restrictions |
  | `messaging_product` | `String.t()` | Messaging product |
  | `permission` | `map()` | Call permission details |
  """

  @type t :: %__MODULE__{
          actions: list(map()) | nil,
          messaging_product: String.t(),
          permission: map()
        }
  @enforce_keys [:messaging_product, :permission]
  defstruct [
    :actions,
    :messaging_product,
    :permission
  ]
end
