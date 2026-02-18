defmodule WhatsApp.Resources.CurrencyObject do
  @moduledoc false

  @type t :: %__MODULE__{
          amount_1000: integer(),
          code: String.t(),
          fallback_value: String.t()
        }
  @enforce_keys [:fallback_value, :code, :amount_1000]
  defstruct [
    :amount_1000,
    :code,
    :fallback_value
  ]
end
