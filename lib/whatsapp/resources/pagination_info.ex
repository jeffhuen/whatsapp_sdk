defmodule WhatsApp.Resources.PaginationInfo do
  @moduledoc """
  Pagination information for navigating through results

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `cursors` | `map()` | Pagination cursors for navigation |
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
