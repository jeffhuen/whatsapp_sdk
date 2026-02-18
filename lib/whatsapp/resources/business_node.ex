defmodule WhatsApp.Resources.BusinessNode do
  @moduledoc """
  Business entity associated with the user
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
