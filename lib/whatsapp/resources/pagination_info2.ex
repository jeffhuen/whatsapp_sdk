defmodule WhatsApp.Resources.PaginationInfo2 do
  @moduledoc """
  Pagination information for cursor-based pagination
  """

  @type t :: %__MODULE__{
          cursors: map() | nil,
          paging: map() | nil
        }
  defstruct [
    :cursors,
    :paging
  ]
end
