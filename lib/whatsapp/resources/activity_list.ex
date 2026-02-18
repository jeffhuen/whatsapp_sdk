defmodule WhatsApp.Resources.ActivityList do
  @moduledoc """
  Paginated list of WhatsApp Business Account activities

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of activity records |
  | `paging` | `map()` |  |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessAccountActivity.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
