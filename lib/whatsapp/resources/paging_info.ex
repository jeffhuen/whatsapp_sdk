defmodule WhatsApp.Resources.PagingInfo do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `cursors` | `map()` |  |
  | `next` | `String.t()` | Next page URL |
  | `previous` | `String.t()` | Previous page URL |
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
