defmodule WhatsApp.Resources.WhatsAppBusinessEncryptionUploadRequest do
  @moduledoc """
  Request payload for uploading business public key
  """

  @type t :: %__MODULE__{
          business_public_key: String.t()
        }
  @enforce_keys [:business_public_key]
  defstruct [
    :business_public_key
  ]
end
