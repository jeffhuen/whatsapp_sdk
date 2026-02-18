defmodule WhatsApp.Resources.UpdateFlowJson do
  @moduledoc false

  @type t :: %__MODULE__{
          success: boolean() | nil,
          validation_errors: list(map()) | nil
        }
  defstruct [
    :success,
    :validation_errors
  ]
end
