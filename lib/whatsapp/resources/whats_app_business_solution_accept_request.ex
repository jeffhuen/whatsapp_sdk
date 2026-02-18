defmodule WhatsApp.Resources.WhatsAppBusinessSolutionAcceptRequest do
  @moduledoc """
  Request payload for accepting a Multi-Partner Solution invitation

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
