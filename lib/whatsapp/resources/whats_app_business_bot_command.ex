defmodule WhatsApp.Resources.WhatsAppBusinessBotCommand do
  @moduledoc """
  Bot command configuration with name and description
  """

  @type t :: %__MODULE__{
          command_description: String.t(),
          command_name: String.t()
        }
  @enforce_keys [:command_name, :command_description]
  defstruct [
    :command_description,
    :command_name
  ]
end
