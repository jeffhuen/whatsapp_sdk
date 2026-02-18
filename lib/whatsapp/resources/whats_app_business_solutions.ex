defmodule WhatsApp.Resources.WhatsAppBusinessSolutions do
  @moduledoc """
  Response containing list of Multi-Partner Solutions with pagination
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.WhatsAppBusinessSolution.t()) | nil,
          paging: map() | nil
        }
  defstruct [
    :data,
    :paging
  ]
end
