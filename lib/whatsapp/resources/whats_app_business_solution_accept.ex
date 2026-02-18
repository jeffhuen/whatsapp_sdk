defmodule WhatsApp.Resources.WhatsAppBusinessSolutionAccept do
  @moduledoc """
  Successful response confirming solution acceptance

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
