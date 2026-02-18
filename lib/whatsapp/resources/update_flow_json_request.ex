defmodule WhatsApp.Resources.UpdateFlowJsonRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          asset_type: String.t() | nil,
          file: String.t() | nil,
          name: String.t() | nil
        }
  defstruct [
    :asset_type,
    :file,
    :name
  ]
end
