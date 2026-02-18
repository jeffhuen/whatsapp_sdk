defmodule WhatsApp.Resources.ErrorResponse2 do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `error` | `map()` |  |
  """

  @type t :: %__MODULE__{
          error: map() | nil
        }
  defstruct [
    :error
  ]
end
