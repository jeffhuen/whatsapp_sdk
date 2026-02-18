defmodule WhatsApp.Resources.NameObject do
  @moduledoc false

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
