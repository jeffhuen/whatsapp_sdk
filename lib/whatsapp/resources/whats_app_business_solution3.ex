defmodule WhatsApp.Resources.WhatsAppBusinessSolution3 do
  @moduledoc """
  WhatsApp Business Solution information

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Solution ID |
  | `name` | `String.t()` | Solution name |
  | `partner_id` | `String.t()` | Partner ID associated with the solution |
  | `status` | `String.t()` | Current status of the solution |

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
          partner_id: String.t() | nil,
          status: String.t() | nil
        }
  @enforce_keys [:id, :name]
  defstruct [
    :id,
    :name,
    :partner_id,
    :status
  ]
end
