defmodule WhatsApp.Resources.BodyObject do
  @moduledoc """
  An object with the body of the message. Optional for 'product' type, required for other interactive message types.

  ## `text` Constraints

  - Maximum length: 1024
  """

  @type t :: %__MODULE__{
          text: String.t()
        }
  @enforce_keys [:text]
  defstruct [
    :text
  ]
end
