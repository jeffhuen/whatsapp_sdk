defmodule WhatsApp.Resources.CreateFlow do
  @moduledoc false

  @type t :: %__MODULE__{
          id: String.t() | nil
        }
  defstruct [
    :id
  ]
end
