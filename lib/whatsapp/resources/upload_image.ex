defmodule WhatsApp.Resources.UploadImage do
  @moduledoc false

  @type t :: %__MODULE__{
          id: String.t() | nil
        }
  defstruct [
    :id
  ]
end
