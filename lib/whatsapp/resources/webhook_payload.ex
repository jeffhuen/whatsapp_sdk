defmodule WhatsApp.Resources.WebhookPayload do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `entry` | `list()` |  |
  | `object` | `String.t()` | Always 'whatsapp_business_account' for these webhooks. |
  """

  @type t :: %__MODULE__{
          entry: list(WhatsApp.Resources.Entry.t()),
          object: String.t()
        }
  @enforce_keys [:object, :entry]
  defstruct [
    :entry,
    :object
  ]
end
