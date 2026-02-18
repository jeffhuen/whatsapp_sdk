defmodule WhatsApp.Resources.AddPhoneNumbersRequest do
  @moduledoc """
  Request payload for adding a phone number to a business account

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `phone_number` | `String.t()` | Phone number to add to the business account. Accepts E.164 format or formatted numbers
  with spaces, hyphens, and parentheses (e.g., +1234567890, +1 (631) 555-1000, +1-631-555-1000).
  The phone number will be normalized and validated by the endpoint.
   |
  """

  @type t :: %__MODULE__{
          phone_number: String.t()
        }
  @enforce_keys [:phone_number]
  defstruct [
    :phone_number
  ]
end
