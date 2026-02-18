defmodule WhatsApp.Resources.QrCode do
  @moduledoc """
  Complete details of a message QR code

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `String.t()` | Unique 14-character QR code identifier |
  | `creation_time` | `integer()` | Unix timestamp when QR code was created (first-party apps only) |
  | `deep_link_url` | `String.t()` | WhatsApp deep link URL for direct conversation initiation |
  | `prefilled_message` | `String.t()` | Pre-filled message text that appears in customer chat |
  | `qr_image_url` | `String.t()` | QR code image download URL (when format specified in fields) |

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
