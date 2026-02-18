defmodule WhatsApp.Resources.OfficialBusinessAccountStatus do
  @moduledoc """
  Official Business Account status information for a WhatsApp Business Account phone number

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
