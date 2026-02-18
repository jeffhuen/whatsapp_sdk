defmodule WhatsApp.Resources.CursorPaging3 do
  @moduledoc """
  Cursor-based pagination information

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `cursors` | `map()` |  |
  | `next` | `String.t()` | URL for the next page of results |
  | `previous` | `String.t()` | URL for the previous page of results |
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
