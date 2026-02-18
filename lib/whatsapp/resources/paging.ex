defmodule WhatsApp.Resources.Paging do
  @moduledoc false

  @type t :: %__MODULE__{
          cursors: map() | nil
        }
  defstruct [
    :cursors
  ]
end
