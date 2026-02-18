defmodule WhatsApp.Resources.AddressObject do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `HOME` |
  | `WORK` |
  """

  @type t :: %__MODULE__{
          city: String.t() | nil,
          country: String.t() | nil,
          country_code: String.t() | nil,
          state: String.t() | nil,
          street: String.t() | nil,
          type: String.t() | nil,
          zip: String.t() | nil
        }
  defstruct [
    :city,
    :country,
    :country_code,
    :state,
    :street,
    :type,
    :zip
  ]
end
