defmodule WhatsApp.Resources.QrCode do
  @moduledoc """
  Complete details of a message QR code

  ## `code` Constraints

  - Pattern: `^[A-Z2-7]{14}$`
  """

  @type t :: %__MODULE__{
          code: String.t(),
          creation_time: integer() | nil,
          deep_link_url: String.t(),
          prefilled_message: String.t(),
          qr_image_url: String.t() | nil
        }
  @enforce_keys [:code, :prefilled_message, :deep_link_url]
  defstruct [
    :code,
    :creation_time,
    :deep_link_url,
    :prefilled_message,
    :qr_image_url
  ]
end
