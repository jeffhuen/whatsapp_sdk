defmodule WhatsApp.Resources.CurrencyObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `amount_1000` | `integer()` | Amount multiplied by 1000 (e.g., 100000 for $100.00). |
  | `code` | `String.t()` | Currency code as defined in ISO 4217. |
  | `fallback_value` | `String.t()` | Default text if localization fails. |
  """

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
