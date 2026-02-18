defmodule WhatsApp.Resources.WhatsAppBusinessAccount2 do
  @moduledoc """
  WhatsApp Business Account information

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | WhatsApp Business Account ID |
  | `name` | `String.t()` | Business account name |
  | `status` | `String.t()` | Current status of the business account |

  ## `status` Values
  | Value |
  | --- |
  | `ACTIVE` |
  | `INACTIVE` |
  | `PENDING` |
  """

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          status: String.t() | nil
        }
  @enforce_keys [:id, :name]
  defstruct [
    :id,
    :name,
    :status
  ]
end
