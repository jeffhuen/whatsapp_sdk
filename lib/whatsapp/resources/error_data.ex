defmodule WhatsApp.Resources.ErrorData do
  @moduledoc false

  @type t :: %__MODULE__{
          details: String.t() | nil
        }
  defstruct [
    :details
  ]
end
