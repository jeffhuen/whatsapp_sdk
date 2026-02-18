defmodule WhatsApp.Resources.ContactObject do
  @moduledoc false

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
