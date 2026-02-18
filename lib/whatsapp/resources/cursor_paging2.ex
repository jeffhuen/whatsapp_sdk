defmodule WhatsApp.Resources.CursorPaging2 do
  @moduledoc """
  Cursor-based pagination information
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
