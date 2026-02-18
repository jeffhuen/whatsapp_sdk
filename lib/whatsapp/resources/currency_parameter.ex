defmodule WhatsApp.Resources.CurrencyParameter do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `type` | `term()` |  |
  | `currency` | `map()` |  |

  ## `type` Values
  | Value |
  | --- |
  | `currency` |
  """

  @type t :: %__MODULE__{
          type: term(),
          currency: map()
        }
  @enforce_keys [:type, :currency]
  defstruct [
    :type,
    :currency
  ]
end
