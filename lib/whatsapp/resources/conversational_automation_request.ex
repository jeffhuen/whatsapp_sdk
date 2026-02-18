defmodule WhatsApp.Resources.ConversationalAutomationRequest do
  @moduledoc """
  Request payload for configuring conversational automation settings

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
