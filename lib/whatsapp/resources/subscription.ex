defmodule WhatsApp.Resources.Subscription do
  @moduledoc """
  Response after successful subscription operation

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` | Array containing subscription details |
  | `success` | `boolean()` | Indicates whether the subscription operation was successful |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.SubscribedApp.t()) | nil,
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :data,
    :success
  ]
end
