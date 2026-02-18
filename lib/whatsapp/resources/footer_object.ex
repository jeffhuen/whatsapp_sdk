defmodule WhatsApp.Resources.FooterObject do
  @moduledoc """
  An object with the footer of the message. Optional.

  ## `text` Constraints

  - Maximum length: 60
  """

  @type t :: %__MODULE__{
          text: String.t()
        }
  @enforce_keys [:text]
  defstruct [
    :text
  ]
end
