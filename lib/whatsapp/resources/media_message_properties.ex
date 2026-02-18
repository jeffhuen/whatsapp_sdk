defmodule WhatsApp.Resources.MediaMessageProperties do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Media asset ID. A GET request on this ID can provide the asset URL. |
  | `mime_type` | `String.t()` | Media asset MIME type. |
  | `sha256` | `String.t()` | Media asset SHA-256 hash. |
  """

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
