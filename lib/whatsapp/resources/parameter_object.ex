defmodule WhatsApp.Resources.ParameterObject do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `currency` |
  | `date_time` |
  | `document` |
  | `image` |
  | `text` |
  | `video` |
  """

  @type t :: %__MODULE__{
          type: String.t()
        }
  @enforce_keys [:type]
  defstruct [
    :type
  ]
end
