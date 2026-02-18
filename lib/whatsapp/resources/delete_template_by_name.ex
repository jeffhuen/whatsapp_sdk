defmodule WhatsApp.Resources.DeleteTemplateByName do
  @moduledoc false

  @type t :: %__MODULE__{
          success: boolean() | nil
        }
  defstruct [
    :success
  ]
end
