defmodule WhatsApp.Resources.ApplicationNode1 do
  @moduledoc """
  Meta application that processed the delivery status event
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
