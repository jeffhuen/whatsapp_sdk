defmodule WhatsApp.Resources.MessageResponseItem do
  @moduledoc false

  @type t :: %__MODULE__{
          id: String.t()
        }
  @enforce_keys [:id]
  defstruct [
    :id
  ]
end
