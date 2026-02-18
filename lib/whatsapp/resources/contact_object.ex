defmodule WhatsApp.Resources.ContactObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `addresses` | `list()` | Full contact address(es) |
  | `birthday` | `Date.t()` | Date of birth (YYYY-MM-DD format) |
  | `emails` | `list()` | Contact email address(es) |
  | `name` | `map()` |  |
  | `org` | `map()` |  |
  | `phones` | `list()` | Contact phone number(s) |
  | `urls` | `list()` | Contact URL(s) |
  """

  @type t :: %__MODULE__{
          addresses: list(WhatsApp.Resources.AddressObject.t()) | nil,
          birthday: Date.t() | nil,
          emails: list(WhatsApp.Resources.EmailObject.t()) | nil,
          name: map() | nil,
          org: map() | nil,
          phones: list(WhatsApp.Resources.PhoneObject.t()) | nil,
          urls: list(WhatsApp.Resources.UrlObject.t()) | nil
        }
  defstruct [
    :addresses,
    :birthday,
    :emails,
    :name,
    :org,
    :phones,
    :urls
  ]
end
