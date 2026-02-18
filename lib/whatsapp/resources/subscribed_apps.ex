defmodule WhatsApp.Resources.SubscribedApps do
  @moduledoc """
  Response containing list of subscribed applications

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array of subscribed applications |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.SubscribedApp.t())
        }
  @enforce_keys [:data]
  defstruct [
    :data
  ]
end
