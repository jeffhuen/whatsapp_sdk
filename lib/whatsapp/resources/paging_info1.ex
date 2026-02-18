defmodule WhatsApp.Resources.PagingInfo1 do
  @moduledoc """
  Pagination information for the response

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
