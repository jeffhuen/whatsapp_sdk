defmodule WhatsApp.Resources.WhatsAppBusinessAccountMigrationIntent do
  @moduledoc """
  WhatsApp Business Account migration intent details and status

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the migration intent |
  | `status` | `String.t()` | Current status of the WhatsApp Business Account migration intent |

  ## `status` Values
  | Value |
  | --- |
  | `ACCEPTED` |
  | `COMPLETED` |
  | `INITIATED` |
  | `REJECTED` |
  """

  @type t :: %__MODULE__{
          id: String.t(),
          status: String.t()
        }
  @enforce_keys [:id, :status]
  defstruct [
    :id,
    :status
  ]
end
