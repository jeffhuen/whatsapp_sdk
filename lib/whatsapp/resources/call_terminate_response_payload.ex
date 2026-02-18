defmodule WhatsApp.Resources.CallTerminateResponsePayload do
  @moduledoc false

  @type t :: %__MODULE__{
          success: boolean() | nil
        }
  defstruct [
    :success
  ]
end
