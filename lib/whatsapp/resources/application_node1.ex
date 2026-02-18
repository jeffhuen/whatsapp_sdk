defmodule WhatsApp.Resources.ApplicationNode1 do
  @moduledoc """
  Meta application that processed the delivery status event

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the Meta application |
  | `name` | `String.t()` | Name of the Meta application |
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil
        }
  defstruct [
    :id,
    :name
  ]
end
