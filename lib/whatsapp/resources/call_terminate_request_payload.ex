defmodule WhatsApp.Resources.CallTerminateRequestPayload do
  @moduledoc """
  ## `action` Values
  | Value |
  | --- |
  | `terminate` |
  """

  @type t :: %__MODULE__{
          action: String.t(),
          call_id: String.t(),
          messaging_product: String.t()
        }
  @enforce_keys [:messaging_product, :call_id, :action]
  defstruct [
    :action,
    :call_id,
    :messaging_product
  ]
end
