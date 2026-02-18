defmodule WhatsApp.Resources.MigrateFlows do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `failed_flows` | `list()` |  |
  | `migrated_flows` | `list()` |  |
  """

  @type t :: %__MODULE__{
          failed_flows: list(map()) | nil,
          migrated_flows: list(map()) | nil
        }
  defstruct [
    :failed_flows,
    :migrated_flows
  ]
end
