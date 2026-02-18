defmodule WhatsApp.Resources.ContactObject1 do
  @moduledoc false

  @type t :: %__MODULE__{
          addresses: list(map()) | nil,
          birthday: Date.t() | nil,
          emails: list(map()) | nil,
          name: map() | nil,
          org: map() | nil,
          phones: list(map()) | nil,
          urls: list(map()) | nil
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
