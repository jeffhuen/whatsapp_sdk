defmodule WhatsApp.Resources.WhatsAppBusinessAccountBackup do
  @moduledoc """
  Backup data for migrating existing WhatsApp Business accounts

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `data` | `String.t()` | Encrypted backup data for account migration |
  | `password` | `String.t()` | Backup password for account migration |
  """

  @type t :: %__MODULE__{
          data: String.t() | nil,
          password: String.t() | nil
        }
  defstruct [
    :data,
    :password
  ]
end
