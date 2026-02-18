defmodule WhatsApp.Resources.MessageTemplate do
  @moduledoc """
  Message template information

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `id` | `String.t()` | Template ID |
  | `name` | `String.t()` | Template name |
  | `status` | `String.t()` |  |

  ## `status` Values
  | Value |
  | --- |
  | `APPROVED` |
  | `PENDING` |
  | `REJECTED` |
  | `DISABLED` |
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          name: String.t() | nil,
          status: String.t() | nil
        }
  defstruct [
    :id,
    :name,
    :status
  ]
end
