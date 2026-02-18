defmodule WhatsApp.Resources.DateTimeObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `fallback_value` | `String.t()` | Default text. For Cloud API, this fallback value is always used. |
  """

  @type t :: %__MODULE__{
          fallback_value: String.t()
        }
  @enforce_keys [:fallback_value]
  defstruct [
    :fallback_value
  ]
end
