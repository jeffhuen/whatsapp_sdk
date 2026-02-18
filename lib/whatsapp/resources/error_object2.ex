defmodule WhatsApp.Resources.ErrorObject2 do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `integer()` | Error code. |
  | `error_data` | `map()` |  |
  | `href` | `String.t()` | Link to error code documentation. |
  | `message` | `String.t()` | Error code message. |
  | `title` | `String.t()` | Error code title. |
  """

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
