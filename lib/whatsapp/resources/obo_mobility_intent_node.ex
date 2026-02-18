defmodule WhatsApp.Resources.OBOMobilityIntentNode do
  @moduledoc """
  WhatsApp Business Account OBO Mobility Intent Node

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `created_time` | `DateTime.t()` | Timestamp when the OBO mobility intent was created (ISO 8601 format) |
  | `id` | `String.t()` | Unique identifier for the OBO Mobility Intent Node |
  | `solution` | `map()` | Multi-Partner Solution details and configuration |
  | `status` | `String.t()` | Current status of the OBO mobility intent |
  | `updated_time` | `DateTime.t()` | Timestamp when the OBO mobility intent was last updated (ISO 8601 format) |
  | `waba` | `map()` | WhatsApp Business Account details and configuration |

  ## `status` Values
  | Value |
  | --- |
  | `PENDING` |
  | `ACTIVE` |
  | `COMPLETED` |
  | `CANCELLED` |
  | `FAILED` |
  """

  @type t :: %__MODULE__{
          created_time: DateTime.t() | nil,
          id: String.t(),
          solution: map(),
          status: String.t() | nil,
          updated_time: DateTime.t() | nil,
          waba: map()
        }
  @enforce_keys [:id, :waba, :solution]
  defstruct [
    :created_time,
    :id,
    :solution,
    :status,
    :updated_time,
    :waba
  ]
end
