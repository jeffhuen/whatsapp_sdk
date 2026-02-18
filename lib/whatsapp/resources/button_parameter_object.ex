defmodule WhatsApp.Resources.ButtonParameterObject do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `payload` |
  | `text` |
  """

  @type t :: %__MODULE__{
          type: String.t()
        }
  @enforce_keys [:type]
  defstruct [
    :type
  ]
end
