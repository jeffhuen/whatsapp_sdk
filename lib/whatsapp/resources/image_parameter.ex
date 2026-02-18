defmodule WhatsApp.Resources.ImageParameter do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `image` |
  """

  @type t :: %__MODULE__{
          type: term(),
          image: map()
        }
  @enforce_keys [:type, :image]
  defstruct [
    :type,
    :image
  ]
end
