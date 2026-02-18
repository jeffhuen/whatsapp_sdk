defmodule WhatsApp.Resources.WhatsAppBusinessBotCommand do
  @moduledoc """
  Bot command configuration with name and description

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `command_description` | `String.t()` | Description of what the command does |
  | `command_name` | `String.t()` | Name of the bot command |
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
