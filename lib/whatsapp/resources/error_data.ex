defmodule WhatsApp.Resources.ErrorData do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `details` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          details: String.t() | nil
        }
  defstruct [
    :details
  ]
end
