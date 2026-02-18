defmodule WhatsApp.Resources.UpdateWhatsAppBusinessAccount do
  @moduledoc false

  @type t :: %__MODULE__{
          success: boolean() | nil
        }
  defstruct [
    :success
  ]
end
