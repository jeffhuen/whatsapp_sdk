defmodule WhatsApp.Resources.ConversationalAutomation do
  @moduledoc """
  Response after successfully configuring conversational automation

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `success` | `boolean()` | Indicates whether the automation configuration was successful |
  """

  @type t :: %__MODULE__{
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :success
  ]
end
