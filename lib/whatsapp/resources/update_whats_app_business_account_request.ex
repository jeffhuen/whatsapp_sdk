defmodule WhatsApp.Resources.UpdateWhatsAppBusinessAccountRequest do
  @moduledoc """
  ## `name` Constraints

  - Minimum length: 1
  - Maximum length: 100
  """

  @type t :: %__MODULE__{
          name: String.t() | nil,
          timezone_id: String.t() | nil
        }
  defstruct [
    :name,
    :timezone_id
  ]
end
