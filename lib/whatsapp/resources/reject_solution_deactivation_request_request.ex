defmodule WhatsApp.Resources.RejectSolutionDeactivationRequestRequest do
  @moduledoc false

  @type t :: %__MODULE__{
          reject_deactivation_request: boolean()
        }
  @enforce_keys [:reject_deactivation_request]
  defstruct [
    :reject_deactivation_request
  ]
end
