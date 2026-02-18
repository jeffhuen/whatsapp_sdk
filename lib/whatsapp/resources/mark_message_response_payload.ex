defmodule WhatsApp.Resources.MarkMessageResponsePayload do
  @moduledoc false

  @type t :: %__MODULE__{
          success: boolean() | nil
        }
  defstruct [
    :success
  ]
end
