defmodule WhatsApp.Resources.UpdateQrCodeRequest do
  @moduledoc """
  Request payload for updating an existing message QR code

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `String.t()` | 14-character QR code identifier to update |
  | `prefilled_message` | `String.t()` | New pre-filled message text (max 140 characters) |

  ## `code` Constraints

  - Minimum length: 14
  - Maximum length: 14
  - Pattern: `^[A-Z2-7]{14}$`

  ## `prefilled_message` Constraints

  - Maximum length: 140
  """

  @type t :: %__MODULE__{
          code: String.t(),
          prefilled_message: String.t()
        }
  @enforce_keys [:code, :prefilled_message]
  defstruct [
    :code,
    :prefilled_message
  ]
end
