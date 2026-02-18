defmodule WhatsApp.Resources.SubscribedApp do
  @moduledoc """
  Application subscribed to the WABA

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Application ID |
  | `name` | `String.t()` | Application name |
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil
        }
  defstruct [
    :id,
    :name
  ]
end
