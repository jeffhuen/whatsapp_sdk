defmodule WhatsApp.Resources.ButtonTextParameter do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `text` |
  """

  @type t :: %__MODULE__{
          type: term(),
          text: String.t()
        }
  @enforce_keys [:type, :text]
  defstruct [
    :type,
    :text
  ]
end
