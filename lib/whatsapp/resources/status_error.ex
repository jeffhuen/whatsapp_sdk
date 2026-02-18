defmodule WhatsApp.Resources.StatusError do
  @moduledoc false

  @type t :: %__MODULE__{
          code: integer() | nil,
          error_data: map() | nil,
          href: String.t() | nil,
          message: String.t() | nil,
          title: String.t() | nil
        }
  defstruct [
    :code,
    :error_data,
    :href,
    :message,
    :title
  ]
end
