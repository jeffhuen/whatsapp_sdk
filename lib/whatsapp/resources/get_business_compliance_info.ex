defmodule WhatsApp.Resources.GetBusinessComplianceInfo do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `list()` |  |
  """

  @type t :: %__MODULE__{
          data: list(WhatsApp.Resources.BusinessComplianceInfo.t()) | nil
        }
  defstruct [
    :data
  ]
end
