defmodule WhatsApp.Resources.DocumentParameter do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `document` |
  """

  @type t :: %__MODULE__{
          type: term(),
          document: map()
        }
  @enforce_keys [:type, :document]
  defstruct [
    :type,
    :document
  ]
end
