defmodule WhatsApp.Resources.WebhookPayload do
  @moduledoc false

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
