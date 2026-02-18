defmodule WhatsApp.Resources.MediaMessageProperties do
  @moduledoc false

  @type t :: %__MODULE__{
          id: String.t(),
          mime_type: String.t(),
          sha256: String.t()
        }
  @enforce_keys [:mime_type, :sha256, :id]
  defstruct [
    :id,
    :mime_type,
    :sha256
  ]
end
