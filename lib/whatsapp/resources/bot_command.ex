defmodule WhatsApp.Resources.BotCommand do
  @moduledoc """
  Bot command configuration for automated responses

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `command_description` | `String.t()` | Description of what the command does |
  | `command_name` | `String.t()` | Name of the bot command (without leading slash) |

  ## `command_description` Constraints

  - Maximum length: 256

  ## `command_name` Constraints

  - Maximum length: 30
  - Pattern: `^[a-zA-Z0-9_]+$`
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
