defmodule WhatsApp.Resources.WebhookConfiguration do
  @moduledoc """
  Webhook configuration settings

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `override_callback_uri` | `String.t()` | Override callback URI for webhook notifications (can be empty string) |
  | `verify_token` | `String.t()` | Token used to verify webhook requests |
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
