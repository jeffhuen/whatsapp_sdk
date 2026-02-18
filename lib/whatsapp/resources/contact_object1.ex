defmodule WhatsApp.Resources.ContactObject1 do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `addresses` | `list()` |  |
  | `birthday` | `Date.t()` | Contact birthday (YYYY-MM-DD). |
  | `emails` | `list()` |  |
  | `name` | `map()` |  |
  | `org` | `map()` |  |
  | `phones` | `list()` |  |
  | `urls` | `list()` |  |
  """

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
