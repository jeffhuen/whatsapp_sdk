defmodule WhatsApp.Resources.ConversationalAutomationRequest do
  @moduledoc """
  Request payload for configuring conversational automation settings

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `commands` | `list()` | List of bot commands for automated responses |
  | `enable_welcome_message` | `boolean()` | Whether to enable welcome messages for new conversations |
  | `prompts` | `list()` | List of conversation prompts (ice breakers) to help guide customer interactions |

  ## `commands` Constraints

  - Maximum items: 30

  ## `prompts` Constraints

  - Maximum items: 3
  """

  @type t :: %__MODULE__{
          commands: list(WhatsApp.Resources.BotCommand.t()) | nil,
          enable_welcome_message: boolean() | nil,
          prompts: list(String.t()) | nil
        }
  defstruct [
    :commands,
    :prompts,
    enable_welcome_message: false
  ]
end
