defmodule WhatsApp.Resources.GroupProfilePicture do
  @moduledoc false

  @type t :: %__MODULE__{
          mime_type: String.t() | nil,
          sha256: String.t() | nil
        }
  defstruct [
    :mime_type,
    :sha256
  ]
end
