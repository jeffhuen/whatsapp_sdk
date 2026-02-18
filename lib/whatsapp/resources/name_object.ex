defmodule WhatsApp.Resources.NameObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `first_name` | `String.t()` | First name |
  | `formatted_name` | `String.t()` | Formatted full name |
  | `last_name` | `String.t()` | Last name |
  | `middle_name` | `String.t()` | Middle name |
  | `prefix` | `String.t()` | Name prefix |
  | `suffix` | `String.t()` | Name suffix |
  """

  @type t :: %__MODULE__{
          first_name: String.t() | nil,
          formatted_name: String.t() | nil,
          last_name: String.t() | nil,
          middle_name: String.t() | nil,
          prefix: String.t() | nil,
          suffix: String.t() | nil
        }
  defstruct [
    :first_name,
    :formatted_name,
    :last_name,
    :middle_name,
    :prefix,
    :suffix
  ]
end
