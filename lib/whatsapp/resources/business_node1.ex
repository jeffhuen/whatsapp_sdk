defmodule WhatsApp.Resources.BusinessNode1 do
  @moduledoc """
  Business entity information
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
