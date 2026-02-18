defmodule WhatsApp.Resources.ApproveJoinRequests do
  @moduledoc false

  @type t :: %__MODULE__{
          approved_join_requests: list(String.t()) | nil,
          errors: list(WhatsApp.Resources.Error.t()) | nil,
          failed_join_requests: list(map()) | nil,
          messaging_product: String.t() | nil
        }
  defstruct [
    :approved_join_requests,
    :errors,
    :failed_join_requests,
    :messaging_product
  ]
end
