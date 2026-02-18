defmodule WhatsApp.Resources.ButtonPayloadParameter do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `payload` |
  """

  @type t :: %__MODULE__{
          type: term(),
          payload: String.t()
        }
  @enforce_keys [:type, :payload]
  defstruct [
    :type,
    :payload
  ]
end
