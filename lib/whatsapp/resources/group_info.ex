defmodule WhatsApp.Resources.GroupInfo do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `creation_timestamp` | `integer()` | UNIX timestamp in seconds at which the group was created |
  | `description` | `String.t()` | Group description |
  | `id` | `String.t()` | Group ID |
  | `join_approval_mode` | `String.t()` | Join approval mode for the group |
  | `messaging_product` | `String.t()` |  |
  | `participants` | `list()` | List of participants in the group |
  | `subject` | `String.t()` | Group subject |
  | `suspended` | `boolean()` | Returns true if the group has been suspended by WhatsApp |
  | `total_participant_count` | `integer()` | Total number of participants in the group, excluding your business |

  ## `join_approval_mode` Values
  | Value |
  | --- |
  | `approval_required` |
  | `auto_approve` |
  """

  @type t :: %__MODULE__{
          creation_timestamp: integer() | nil,
          description: String.t() | nil,
          id: String.t() | nil,
          join_approval_mode: String.t() | nil,
          messaging_product: String.t() | nil,
          participants: list(map()) | nil,
          subject: String.t() | nil,
          suspended: boolean() | nil,
          total_participant_count: integer() | nil
        }
  defstruct [
    :creation_timestamp,
    :description,
    :id,
    :join_approval_mode,
    :messaging_product,
    :participants,
    :subject,
    :suspended,
    :total_participant_count
  ]
end
