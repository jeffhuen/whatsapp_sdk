defmodule WhatsApp.Resources.GetCreditLines do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` |  |
  """

  @type t :: %__MODULE__{
          data: list(map()) | nil
        }
  defstruct [
    :data
  ]
end
