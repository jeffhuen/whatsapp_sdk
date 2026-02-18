defmodule WhatsApp.Resources.GroupProfilePicture do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `mime_type` | `String.t()` | MIME type of the profile picture |
  | `sha256` | `String.t()` | SHA256 hash of the profile picture |
  """

  @type t :: %__MODULE__{
          mime_type: String.t() | nil,
          sha256: String.t() | nil
        }
  defstruct [
    :mime_type,
    :sha256
  ]
end
