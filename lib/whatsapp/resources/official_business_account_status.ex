defmodule WhatsApp.Resources.OfficialBusinessAccountStatus do
  @moduledoc """
  Official Business Account status information for a WhatsApp Business Account phone number

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the WhatsApp Business Account phone number |
  | `oba_status` | `String.t()` | Official Business Account appeal and verification status |
  | `status_message` | `String.t()` | Human-readable message describing the current Official Business Account status |

  ## `oba_status` Values
  | Value |
  | --- |
  | `PENDING` |
  | `APPROVED` |
  | `REJECTED` |
  | `UNDER_REVIEW` |
  | `EXPIRED` |
  | `CANCELLED` |
  """

  @type t :: %__MODULE__{
          id: String.t(),
          oba_status: String.t(),
          status_message: String.t()
        }
  @enforce_keys [:id, :oba_status, :status_message]
  defstruct [
    :id,
    :oba_status,
    :status_message
  ]
end
