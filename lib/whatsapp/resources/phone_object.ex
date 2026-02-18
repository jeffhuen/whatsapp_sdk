defmodule WhatsApp.Resources.PhoneObject do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `HOME` |
  | `WORK` |
  """

  @type t :: %__MODULE__{
          phone: String.t(),
          type: String.t() | nil,
          wa_id: String.t() | nil
        }
  @enforce_keys [:phone]
  defstruct [
    :phone,
    :type,
    :wa_id
  ]
end
