defmodule WhatsApp.Resources.RejectJoinRequests do
  @moduledoc false

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
