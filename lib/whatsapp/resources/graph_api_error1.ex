defmodule WhatsApp.Resources.GraphAPIError1 do
  @moduledoc """
  Standard Graph API error response structure

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
