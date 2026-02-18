defmodule WhatsApp.Resources.ApproveJoinRequestsRequest do
  @moduledoc """
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
