defmodule WhatsApp.Resources.ApplicationNode do
  @moduledoc """
  Meta application that owns the Multi-Partner Solution
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil
        }
  defstruct [
    :id,
    :name
  ]
end
