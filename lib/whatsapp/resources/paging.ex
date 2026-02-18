defmodule WhatsApp.Resources.Paging do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `cursors` | `map()` |  |
  """

  @type t :: %__MODULE__{
          cursors: map() | nil
        }
  defstruct [
    :cursors
  ]
end
