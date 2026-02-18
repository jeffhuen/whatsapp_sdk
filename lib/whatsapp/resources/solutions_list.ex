defmodule WhatsApp.Resources.SolutionsList do
  @moduledoc """
  Paginated list of Multi-Partner Solutions

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of Multi-Partner Solutions associated with the WABA |
  | `paging` | `map()` |  |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessSolution.t()),
          paging: map() | nil
        }
  @enforce_keys [:data]
  defstruct [
    :data,
    :paging
  ]
end
