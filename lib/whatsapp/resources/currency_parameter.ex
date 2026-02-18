defmodule WhatsApp.Resources.CurrencyParameter do
  @moduledoc """
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
