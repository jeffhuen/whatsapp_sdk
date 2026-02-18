defmodule WhatsApp.Resources.Groups do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `added_participants` | `list()` | List of participants added to the group |
  | `description` | `String.t()` | Group description |
  | `group_id` | `String.t()` | Unique identifier for the group |
  | `profile_picture` | `map()` |  |
  | `removed_participants` | `list()` | List of participants removed from the group |
  | `request_id` | `String.t()` | Unique identifier for the request |
  | `subject` | `String.t()` | Group subject/name |
  | `timestamp` | `integer()` | Unix timestamp of the group event |
  | `type` | `String.t()` | Type of group event |

  ## `type` Values
  | Value |
  | --- |
  | `group_create` |
  | `group_delete` |
  | `group_settings_update` |
  | `group_add_participants` |
  | `group_remove_participants` |
  """

  @type t :: %__MODULE__{
          added_participants: list(WhatsApp.Resources.GroupParticipant.t()) | nil,
          description: String.t() | nil,
          group_id: String.t(),
          profile_picture: map() | nil,
          removed_participants: list(WhatsApp.Resources.GroupParticipant.t()) | nil,
          request_id: String.t(),
          subject: String.t() | nil,
          timestamp: integer(),
          type: String.t()
        }
  @enforce_keys [:timestamp, :group_id, :type, :request_id]
  defstruct [
    :added_participants,
    :description,
    :group_id,
    :profile_picture,
    :removed_participants,
    :request_id,
    :subject,
    :timestamp,
    :type
  ]
end
