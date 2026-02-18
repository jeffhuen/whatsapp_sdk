defmodule WhatsApp.Resources.ErrorObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `integer()` | Numeric error code |
  | `message` | `String.t()` | Human-readable description of the error |
  | `type` | `String.t()` | Error type classification |
  """

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
