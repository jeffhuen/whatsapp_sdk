defmodule WhatsApp.Resources.Pricing do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `billable` | `boolean()` |  |
  | `category` | `String.t()` |  |
  | `pricing_model` | `String.t()` |  |

  ## `pricing_model` Values
  | Value |
  | --- |
  | `CBP` |
  | `PMP` |
  """

  @type t :: %__MODULE__{
          billable: boolean() | nil,
          category: String.t() | nil,
          pricing_model: String.t() | nil
        }
  defstruct [
    :billable,
    :category,
    :pricing_model
  ]
end
