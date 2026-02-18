defmodule WhatsApp.Resources.MigrateFlows do
  @moduledoc false

  @type t :: %__MODULE__{
          failed_flows: list(map()) | nil,
          migrated_flows: list(map()) | nil
        }
  defstruct [
    :failed_flows,
    :migrated_flows
  ]
end
