defmodule WhatsApp.Resources.AddPhoneNumbersRequest do
  @moduledoc """
  Request payload for adding a phone number to a business account
  """

  @type t :: %__MODULE__{
          phone_number: String.t()
        }
  @enforce_keys [:phone_number]
  defstruct [
    :phone_number
  ]
end
