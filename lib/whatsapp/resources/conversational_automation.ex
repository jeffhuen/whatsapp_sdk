defmodule WhatsApp.Resources.ConversationalAutomation do
  @moduledoc """
  Response after successfully configuring conversational automation
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
