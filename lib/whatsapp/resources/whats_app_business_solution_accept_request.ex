defmodule WhatsApp.Resources.WhatsAppBusinessSolutionAcceptRequest do
  @moduledoc """
  Request payload for accepting a Multi-Partner Solution invitation

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `log_session_id` | `String.t()` | Optional session identifier for logging and debugging purposes.
  Used to track the acceptance flow across multiple API calls.
   |
  | `partner_app_id` | `String.t()` | ID of the partner application accepting the solution invitation.
  This must match the app ID that received the original invitation.
   |

  ## `partner_app_id` Constraints

  - Pattern: `^[0-9]+$`
  """

  @type t :: %__MODULE__{
          log_session_id: String.t() | nil,
          partner_app_id: String.t()
        }
  @enforce_keys [:partner_app_id]
  defstruct [
    :log_session_id,
    :partner_app_id
  ]
end
