defmodule WhatsApp.Resources.BaseMessageProperties1 do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `from` | `String.t()` | WhatsApp user phone number. Note that a WhatsApp user's phone number and ID may not always match. |
  | `id` | `String.t()` | Unique WhatsApp message ID. |
  | `timestamp` | `String.t()` | Unix timestamp indicating when the webhook was triggered. |
  """

  @type t :: %__MODULE__{
          from: String.t(),
          id: String.t(),
          timestamp: String.t()
        }
  @enforce_keys [:from, :id, :timestamp]
  defstruct [
    :from,
    :id,
    :timestamp
  ]
end
