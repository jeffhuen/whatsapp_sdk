defmodule WhatsApp.Resources.SubscribedApp1 do
  @moduledoc """
  Subscribed application details
  """

  @type t :: %__MODULE__{
          override_callback_uri: String.t() | nil,
          whatsapp_business_api_data: map()
        }
  @enforce_keys [:whatsapp_business_api_data]
  defstruct [
    :override_callback_uri,
    :whatsapp_business_api_data
  ]
end
