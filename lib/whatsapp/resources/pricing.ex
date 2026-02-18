defmodule WhatsApp.Resources.Pricing do
  @moduledoc """
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
