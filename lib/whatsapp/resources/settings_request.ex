defmodule WhatsApp.Resources.SettingsRequest do
  @moduledoc """
  Request to update phone number settings
  """

  @type t :: %__MODULE__{
          calling: map() | nil
        }
  defstruct [
    :calling
  ]
end
