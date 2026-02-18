defmodule WhatsApp.Resources.PhoneNumber do
  @moduledoc """
  Phone number associated with the WABA

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `display_phone_number` | `String.t()` | Formatted phone number for display |
  | `id` | `String.t()` | Phone number ID |
  | `verified_name` | `String.t()` | Verified business name for the phone number |
  """

  @type t :: %__MODULE__{
          display_phone_number: String.t() | nil,
          id: String.t() | nil,
          verified_name: String.t() | nil
        }
  defstruct [
    :display_phone_number,
    :id,
    :verified_name
  ]
end
