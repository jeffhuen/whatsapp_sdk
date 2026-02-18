defmodule WhatsApp.Resources.WebhookConfiguration do
  @moduledoc """
  Webhook configuration settings
  """

  @type t :: %__MODULE__{
          override_callback_uri: String.t(),
          verify_token: String.t() | nil
        }
  @enforce_keys [:override_callback_uri]
  defstruct [
    :override_callback_uri,
    :verify_token
  ]
end
