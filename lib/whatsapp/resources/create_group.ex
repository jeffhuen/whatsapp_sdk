defmodule WhatsApp.Resources.CreateGroup do
  @moduledoc false

  @type t :: %__MODULE__{
          messaging_product: String.t() | nil,
          request_id: String.t() | nil
        }
  defstruct [
    :messaging_product,
    :request_id
  ]
end
