defmodule WhatsApp.Resources.WhatsAppBusinessBot do
  @moduledoc """
  WhatsApp Business Bot configuration and details
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
