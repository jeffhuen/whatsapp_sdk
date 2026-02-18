defmodule WhatsApp.Resources.UploadImageRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          file: String.t() | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :file,
    :messaging_product
  ]
end
