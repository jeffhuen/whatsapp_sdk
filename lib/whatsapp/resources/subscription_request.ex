defmodule WhatsApp.Resources.SubscriptionRequest do
  @moduledoc """
  Request body for subscribing to WABA webhooks
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
