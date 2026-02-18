defmodule WhatsApp.Resources.WhatsAppBusinessAccountMigrationIntent do
  @moduledoc """
  WhatsApp Business Account migration intent details and status

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
