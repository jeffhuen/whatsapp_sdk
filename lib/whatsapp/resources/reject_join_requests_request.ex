defmodule WhatsApp.Resources.RejectJoinRequestsRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `join_requests` | `list()` | Array of join request IDs to reject |
  | `messaging_product` | `String.t()` |  |

  ## `messaging_product` Values
  | Value |
  | --- |
  | `whatsapp` |
  """

  @type t :: %__MODULE__{
          join_requests: list(String.t()),
          messaging_product: String.t()
        }
  @enforce_keys [:messaging_product, :join_requests]
  defstruct [
    :join_requests,
    :messaging_product
  ]
end
