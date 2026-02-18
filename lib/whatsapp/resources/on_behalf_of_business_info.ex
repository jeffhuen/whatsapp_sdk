defmodule WhatsApp.Resources.OnBehalfOfBusinessInfo do
  @moduledoc """
  Information about the business on whose behalf the WABA operates
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
