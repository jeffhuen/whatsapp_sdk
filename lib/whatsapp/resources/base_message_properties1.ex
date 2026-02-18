defmodule WhatsApp.Resources.BaseMessageProperties1 do
  @moduledoc false

  @type t :: %__MODULE__{
          from: String.t(),
          id: String.t(),
          timestamp: String.t()
        }
  @enforce_keys [:from, :id, :timestamp]
  defstruct [
    :from,
    :id,
    :timestamp
  ]
end
