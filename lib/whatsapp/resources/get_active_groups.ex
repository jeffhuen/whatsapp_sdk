defmodule WhatsApp.Resources.GetActiveGroups do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `map()` |  |
  | `paging` | `map()` |  |
  """

  @type t :: %__MODULE__{
          data: map() | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
