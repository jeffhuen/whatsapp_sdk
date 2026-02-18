defmodule WhatsApp.Resources.SolutionsList do
  @moduledoc """
  Paginated list of Multi-Partner Solutions
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
