defmodule WhatsApp.Resources.Paging1 do
  @moduledoc """
  Pagination information for cursor-based pagination
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
