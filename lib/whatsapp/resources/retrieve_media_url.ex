defmodule WhatsApp.Resources.RetrieveMediaUrl do
  @moduledoc false

  @type t :: %__MODULE__{
          file_size: String.t() | nil,
          id: String.t() | nil,
          messaging_product: String.t() | nil,
          mime_type: String.t() | nil,
          sha256: String.t() | nil,
          url: String.t() | nil
        }
  defstruct [
    :file_size,
    :id,
    :messaging_product,
    :mime_type,
    :sha256,
    :url
  ]
end
