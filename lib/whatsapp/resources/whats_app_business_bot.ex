defmodule WhatsApp.Resources.WhatsAppBusinessBot do
  @moduledoc """
  WhatsApp Business Bot configuration and details

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `commands` | `list()` | List of available bot commands and their descriptions |
  | `enable_welcome_message` | `boolean()` | Whether the welcome message is enabled for this bot |
  | `id` | `String.t()` | Unique identifier for the WhatsApp Business Bot |
  | `prompts` | `list()` | List of bot prompts and automated responses |
  """

  @type t :: %__MODULE__{
          commands: list(WhatsApp.Resources.WhatsAppBusinessBotCommand.t()) | nil,
          enable_welcome_message: boolean() | nil,
          id: String.t(),
          prompts: list(String.t()) | nil
        }
  @enforce_keys [:id]
  defstruct [
    :commands,
    :enable_welcome_message,
    :id,
    :prompts
  ]
end
