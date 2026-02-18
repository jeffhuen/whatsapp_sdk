defmodule WhatsApp.Resources.Subscription do
  @moduledoc """
  Response after successful subscription operation
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
