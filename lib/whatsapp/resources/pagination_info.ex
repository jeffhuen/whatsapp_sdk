defmodule WhatsApp.Resources.PaginationInfo do
  @moduledoc """
  Pagination information for navigating through results
  """

  @type t :: %__MODULE__{
          cursors: map() | nil,
          next: String.t() | nil,
          previous: String.t() | nil
        }
  defstruct [
    :cursors,
    :next,
    :previous
  ]
end
