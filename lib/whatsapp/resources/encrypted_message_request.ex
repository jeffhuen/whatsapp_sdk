defmodule WhatsApp.Resources.EncryptedMessageRequest do
  @moduledoc """
  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |
  """

  @type t :: %__MODULE__{
          encrypted_contents: String.t(),
          messaging_product: String.t()
        }
  @enforce_keys [:messaging_product, :encrypted_contents]
  defstruct [
    :encrypted_contents,
    :messaging_product
  ]
end
