defmodule WhatsApp.Resources.Conversation do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `expiration_timestamp` | `String.t()` |  |
  | `id` | `String.t()` |  |
  | `origin` | `map()` |  |
  """

  @type t :: %__MODULE__{
          expiration_timestamp: String.t() | nil,
          id: String.t() | nil,
          origin: map() | nil
        }
  defstruct [
    :expiration_timestamp,
    :id,
    :origin
  ]
end
