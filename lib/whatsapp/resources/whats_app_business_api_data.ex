defmodule WhatsApp.Resources.WhatsAppBusinessApiData do
  @moduledoc """
  WhatsApp Business API configuration data

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `notify_user_change_number` | `boolean()` | Whether to notify users when changing number |
  | `pin` | `String.t()` | Two-step verification PIN (can be empty string) |
  | `show_security_notifications` | `boolean()` | Whether to show security notifications |
  """

  @type t :: %__MODULE__{
          notify_user_change_number: boolean() | nil,
          pin: String.t() | nil,
          show_security_notifications: boolean() | nil
        }
  defstruct [
    :notify_user_change_number,
    :pin,
    :show_security_notifications
  ]
end
