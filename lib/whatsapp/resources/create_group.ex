defmodule WhatsApp.Resources.CreateGroup do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `messaging_product` | `String.t()` |  |
  | `request_id` | `String.t()` | Group creation request ID |
  """

  @type t :: %__MODULE__{
          messaging_product: String.t() | nil,
          request_id: String.t() | nil
        }
  defstruct [
    :messaging_product,
    :request_id
  ]
end
