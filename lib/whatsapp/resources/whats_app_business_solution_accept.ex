defmodule WhatsApp.Resources.WhatsAppBusinessSolutionAccept do
  @moduledoc """
  Successful response confirming solution acceptance

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `message` | `String.t()` | Human-readable confirmation message |
  | `partner_status` | `String.t()` | Current status of the partner's participation in the Multi-Partner Solution |
  | `solution_id` | `String.t()` | ID of the Multi-Partner Solution that was accepted |
  | `success` | `boolean()` | Indicates whether the acceptance was successful |
  | `update_time` | `DateTime.t()` | Timestamp when the acceptance was processed |

  ## `partner_status` Values
  | Value |
  | --- |
  | `DRAFT` |
  | `INITIATED` |
  | `NOTIFICATION_SENT` |
  | `ACCEPTED` |
  | `REJECTED` |
  | `DEACTIVATED` |
  """

  @type t :: %__MODULE__{
          message: String.t() | nil,
          partner_status: String.t(),
          solution_id: String.t(),
          success: boolean(),
          update_time: DateTime.t() | nil
        }
  @enforce_keys [:solution_id, :partner_status, :success]
  defstruct [
    :message,
    :partner_status,
    :solution_id,
    :success,
    :update_time
  ]
end
