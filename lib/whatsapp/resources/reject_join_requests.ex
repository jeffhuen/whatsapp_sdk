defmodule WhatsApp.Resources.RejectJoinRequests do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `errors` | `list()` |  |
  | `failed_join_requests` | `list()` |  |
  | `messaging_product` | `String.t()` |  |
  | `rejected_join_requests` | `list()` |  |
  """

  @type t :: %__MODULE__{
          errors: list(WhatsApp.Resources.Error.t()) | nil,
          failed_join_requests: list(map()) | nil,
          messaging_product: String.t() | nil,
          rejected_join_requests: list(String.t()) | nil
        }
  defstruct [
    :errors,
    :failed_join_requests,
    :messaging_product,
    :rejected_join_requests
  ]
end
