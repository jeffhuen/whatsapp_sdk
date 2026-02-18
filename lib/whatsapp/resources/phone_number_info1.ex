defmodule WhatsApp.Resources.PhoneNumberInfo1 do
  @moduledoc """
  Phone number information for WhatsApp Business Account

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `display_phone_number` | `String.t()` | Formatted phone number for display |
  | `id` | `String.t()` | Phone number ID |
  | `status` | `String.t()` | Status of the phone number |
  | `verified_name` | `String.t()` | Verified business name for this phone number |

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
