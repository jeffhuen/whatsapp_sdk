defmodule WhatsApp.Resources.Change do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `field` | `String.t()` | The field indicate to what object is the webhook related:
  - messages: the webhook is related to messages from consumer or status of message sent by business to consumer.
  - group_lifecycle_update: the webhook is related to group creation and deletion.
  - group_settings_update: the webhook is related to group settings update.
  - group_participant_update: the webhook is related to participants joining and leaving the groups.
   |
  | `value` | `term()` |  |

  ## `field` Values
  | Value |
  | --- |
  | `messages` |
  | `group_lifecycle_update` |
  | `group_settings_update` |
  | `group_participant_update` |
  """

  @type t :: %__MODULE__{
          field: String.t(),
          value: term()
        }
  @enforce_keys [:value, :field]
  defstruct [
    :field,
    :value
  ]
end
