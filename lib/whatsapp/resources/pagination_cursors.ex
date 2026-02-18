defmodule WhatsApp.Resources.PaginationCursors do
  @moduledoc false

  @type t :: %__MODULE__{
          after: String.t() | nil,
          before: String.t() | nil
        }
  defstruct [
    :after,
    :before
  ]
end
