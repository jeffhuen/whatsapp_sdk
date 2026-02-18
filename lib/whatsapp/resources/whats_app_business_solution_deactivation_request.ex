defmodule WhatsApp.Resources.WhatsAppBusinessSolutionDeactivationRequest do
  @moduledoc """
  Request payload for sending a Multi-Partner Solution deactivation request

  ## `reason` Constraints

  - Maximum length: 500
  """

  @type t :: %__MODULE__{
          reason: String.t() | nil
        }
  defstruct [
    :reason
  ]
end
