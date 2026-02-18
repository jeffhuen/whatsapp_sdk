defmodule WhatsApp.Resources.Error do
  @moduledoc false

  @type t :: %__MODULE__{
          code: integer() | nil,
          error_data: map() | nil,
          message: String.t() | nil,
          title: String.t() | nil
        }
  defstruct [
    :code,
    :error_data,
    :message,
    :title
  ]
end
