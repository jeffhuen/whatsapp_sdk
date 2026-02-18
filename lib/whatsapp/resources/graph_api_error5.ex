defmodule WhatsApp.Resources.GraphAPIError5 do
  @moduledoc """
  Standard Graph API error response

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `error` | `map()` |  |
  """

  @type t :: %__MODULE__{
          error: map()
        }
  @enforce_keys [:error]
  defstruct [
    :error
  ]
end
