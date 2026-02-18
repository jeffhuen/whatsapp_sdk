defmodule WhatsApp.Resources.PhoneNumberInfo1 do
  @moduledoc """
  Phone number information for WhatsApp Business Account

  ## `status` Values
  | Value |
  | --- |
  | `CONNECTED` |
  | `DISCONNECTED` |
  | `MIGRATED` |
  | `PENDING` |
  | `DELETED` |
  """

  @type t :: %__MODULE__{
          display_phone_number: String.t() | nil,
          id: String.t() | nil,
          status: String.t() | nil,
          verified_name: String.t() | nil
        }
  defstruct [
    :display_phone_number,
    :id,
    :status,
    :verified_name
  ]
end
