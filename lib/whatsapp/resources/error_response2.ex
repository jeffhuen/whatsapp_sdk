defmodule WhatsApp.Resources.ErrorResponse2 do
  @moduledoc false

  @type t :: %__MODULE__{
          error: map() | nil
        }
  defstruct [
    :error
  ]
end
