defmodule WhatsApp.Resources.UpdateWhatsAppBusinessAccountRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `name` | `String.t()` | Updated name for the WhatsApp Business Account |
  | `timezone_id` | `String.t()` | Updated timezone identifier for the WhatsApp Business Account |

  ## `name` Constraints

  - Minimum length: 1
  - Maximum length: 100
  """

  @type t :: %__MODULE__{
          name: String.t() | nil,
          timezone_id: String.t() | nil
        }
  defstruct [
    :name,
    :timezone_id
  ]
end
