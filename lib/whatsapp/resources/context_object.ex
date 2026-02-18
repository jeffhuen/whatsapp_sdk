defmodule WhatsApp.Resources.ContextObject do
  @moduledoc """
  Only included if message via a "Message business" button.
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
