defmodule WhatsApp.Resources.StatusError do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `integer()` |  |
  | `error_data` | `map()` |  |
  | `href` | `String.t()` |  |
  | `message` | `String.t()` |  |
  | `title` | `String.t()` |  |
  """

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
