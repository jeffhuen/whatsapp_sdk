defmodule WhatsApp.Resources.WhatsAppBusinessApiData1 do
  @moduledoc """
  Application subscription data for WhatsApp Business Account

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Unique identifier for the subscribed application |
  | `link` | `String.t()` | URL link to the application |
  | `name` | `String.t()` | Name of the subscribed application |
  """

  @type t :: %__MODULE__{
          id: String.t(),
          link: String.t() | nil,
          name: String.t()
        }
  @enforce_keys [:id, :name]
  defstruct [
    :id,
    :link,
    :name
  ]
end
