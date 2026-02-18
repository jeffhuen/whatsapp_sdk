defmodule WhatsApp.Resources.PaginationCursors do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `after` | `String.t()` |  |
  | `before` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          after: String.t() | nil,
          before: String.t() | nil
        }
  defstruct [
    :after,
    :before
  ]
end
