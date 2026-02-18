defmodule WhatsApp.Resources.WhatsAppBusinessAccountBackup do
  @moduledoc """
  Backup data for migrating existing WhatsApp Business accounts
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
