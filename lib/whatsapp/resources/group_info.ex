defmodule WhatsApp.Resources.GroupInfo do
  @moduledoc """
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
