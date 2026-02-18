defmodule WhatsApp.Resources.MigrateFlowsRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          source_flow_names: String.t() | nil,
          source_waba_id: String.t() | nil
        }
  defstruct [
    :source_flow_names,
    :source_waba_id
  ]
end
