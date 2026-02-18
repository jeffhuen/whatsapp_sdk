defmodule WhatsApp.Resources.ConnectedClientBusinesses do
  @moduledoc """
  Response containing list of connected client businesses

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of connected client businesses |
  | `paging` | `map()` | Cursor-based pagination information |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.ConnectedClientBusiness.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
