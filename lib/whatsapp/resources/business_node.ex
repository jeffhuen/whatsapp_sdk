defmodule WhatsApp.Resources.BusinessNode do
  @moduledoc """
  Business entity associated with the user

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the business |
  | `name` | `String.t()` | Name of the business |
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
