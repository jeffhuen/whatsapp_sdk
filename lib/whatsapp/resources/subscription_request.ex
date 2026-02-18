defmodule WhatsApp.Resources.SubscriptionRequest do
  @moduledoc """
  Request body for subscribing to WABA webhooks

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `override_callback_uri` | `String.t()` | Custom webhook callback URL to override app default |
  | `verify_token` | `String.t()` | Verification token for webhook security |
  """

  @type t :: %__MODULE__{
          override_callback_uri: String.t() | nil,
          verify_token: String.t() | nil
        }
  defstruct [
    :override_callback_uri,
    :verify_token
  ]
end
