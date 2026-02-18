defmodule WhatsApp.Resources.PhoneObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `phone` | `String.t()` | Phone number |
  | `type` | `String.t()` | Phone type |
  | `wa_id` | `String.t()` | WhatsApp ID |

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
