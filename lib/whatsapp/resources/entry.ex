defmodule WhatsApp.Resources.Entry do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `changes` | `list()` |  |
  | `id` | `String.t()` | WhatsApp Business Account ID. |
  """

  @type t :: %__MODULE__{
          changes: list(WhatsApp.Resources.Change.t()),
          id: String.t()
        }
  @enforce_keys [:id, :changes]
  defstruct [
    :changes,
    :id
  ]
end
