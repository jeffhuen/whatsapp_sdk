defmodule WhatsApp.Resources.PayloadEncryptionSettings do
  @moduledoc """
  ## `status` Values
  | Value |
  | --- |
  | `enabled` |
  | `disabled` |
  """

  @type t :: %__MODULE__{
          client_encryption_key: String.t() | nil,
          status: String.t()
        }
  @enforce_keys [:status]
  defstruct [
    :client_encryption_key,
    :status
  ]
end
