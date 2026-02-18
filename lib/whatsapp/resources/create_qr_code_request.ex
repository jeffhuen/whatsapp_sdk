defmodule WhatsApp.Resources.CreateQrCodeRequest do
  @moduledoc """
  Request payload for creating a new message QR code

  ## `generate_qr_image` Values
  | Value |
  | --- |
  | `PNG` |
  | `SVG` |

  ## `prefilled_message` Constraints

  - Maximum length: 140
  """

  @type t :: %__MODULE__{
          generate_qr_image: String.t() | nil,
          prefilled_message: String.t()
        }
  @enforce_keys [:prefilled_message]
  defstruct [
    :generate_qr_image,
    :prefilled_message
  ]
end
