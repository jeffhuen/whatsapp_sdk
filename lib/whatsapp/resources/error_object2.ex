defmodule WhatsApp.Resources.ErrorObject2 do
  @moduledoc false

  @type t :: %__MODULE__{
          code: integer(),
          error_data: map(),
          href: String.t() | nil,
          message: String.t(),
          title: String.t()
        }
  @enforce_keys [:code, :title, :message, :error_data]
  defstruct [
    :code,
    :error_data,
    :href,
    :message,
    :title
  ]
end
