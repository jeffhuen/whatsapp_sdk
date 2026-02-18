defmodule WhatsApp.Resources.Error do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code` | `integer()` | Error code |
  | `error_data` | `map()` |  |
  | `message` | `String.t()` | Error message |
  | `title` | `String.t()` | Error title |
  """

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
