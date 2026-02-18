defmodule WhatsApp.Resources.WhatsAppBusinessApiData do
  @moduledoc """
  WhatsApp Business API configuration data
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
