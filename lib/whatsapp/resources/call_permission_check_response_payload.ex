defmodule WhatsApp.Resources.CallPermissionCheckResponsePayload do
  @moduledoc false

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
