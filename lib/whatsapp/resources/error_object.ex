defmodule WhatsApp.Resources.ErrorObject do
  @moduledoc false

  @type t :: %__MODULE__{
          code: integer(),
          message: String.t(),
          type: String.t()
        }
  @enforce_keys [:message, :type, :code]
  defstruct [
    :code,
    :message,
    :type
  ]
end
