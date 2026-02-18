defmodule WhatsApp.Resources.AddressObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `city` | `String.t()` | City name |
  | `country` | `String.t()` | Full country name |
  | `country_code` | `String.t()` | Two-letter ISO country code |
  | `state` | `String.t()` | State abbreviation |
  | `street` | `String.t()` | Street address |
  | `type` | `String.t()` | Address type |
  | `zip` | `String.t()` | ZIP code |

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
