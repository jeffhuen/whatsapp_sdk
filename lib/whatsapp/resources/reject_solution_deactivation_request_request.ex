defmodule WhatsApp.Resources.RejectSolutionDeactivationRequestRequest do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `reject_deactivation_request` | `boolean()` | Set to true to reject the pending deactivation request |
  """

  @type t :: %__MODULE__{
          reject_deactivation_request: boolean()
        }
  @enforce_keys [:reject_deactivation_request]
  defstruct [
    :reject_deactivation_request
  ]
end
