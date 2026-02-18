defmodule WhatsApp.Resources.Paging1 do
  @moduledoc """
  Pagination information for cursor-based pagination

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `cursors` | `map()` |  |
  | `next` | `String.t()` | Graph API endpoint URL for the next page of data |
  | `previous` | `String.t()` | Graph API endpoint URL for the previous page of data |
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
