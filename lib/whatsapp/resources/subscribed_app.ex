defmodule WhatsApp.Resources.SubscribedApp do
  @moduledoc """
  Application subscribed to the WABA
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
