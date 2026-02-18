defmodule WhatsApp.Resources.CreateFlowRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          categories: String.t() | nil,
          clone_flow_id: String.t() | nil,
          endpoint_uri: String.t() | nil,
          name: String.t() | nil
        }
  defstruct [
    :categories,
    :clone_flow_id,
    :endpoint_uri,
    :name
  ]
end
