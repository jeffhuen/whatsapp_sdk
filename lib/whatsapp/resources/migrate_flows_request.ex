defmodule WhatsApp.Resources.MigrateFlowsRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `source_flow_names` | `String.t()` | [Optional] The names of the flows that will be copied from the source WABA. If not specified, all flows in the source WABA will be copied |
  | `source_waba_id` | `String.t()` | The ID of the source WABA from which the flows will be copied |
  """

  @type t :: %__MODULE__{
          source_flow_names: String.t() | nil,
          source_waba_id: String.t() | nil
        }
  defstruct [
    :source_flow_names,
    :source_waba_id
  ]
end
