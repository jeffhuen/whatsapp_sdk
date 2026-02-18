defmodule WhatsApp.Resources.PhoneNumber do
  @moduledoc """
  Phone number associated with the WABA
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
