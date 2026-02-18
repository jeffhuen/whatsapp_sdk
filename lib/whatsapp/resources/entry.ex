defmodule WhatsApp.Resources.Entry do
  @moduledoc false

  @type t :: %__MODULE__{
          changes: list(WhatsApp.Resources.Change.t()),
          id: String.t()
        }
  @enforce_keys [:id, :changes]
  defstruct [
    :changes,
    :id
  ]
end
