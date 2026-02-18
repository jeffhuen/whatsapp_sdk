defmodule WhatsApp.Resources.ContextObject do
  @moduledoc """
  Only included if message via a "Message business" button.

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `from` | `String.t()` | Business display phone number. |
  | `id` | `String.t()` | WhatsApp message ID of the message the user used to access the "Message business" button. |
  | `referred_product` | `map()` |  |
  """

  @type t :: %__MODULE__{
          from: String.t(),
          id: String.t(),
          referred_product: map()
        }
  @enforce_keys [:from, :id, :referred_product]
  defstruct [
    :from,
    :id,
    :referred_product
  ]
end
