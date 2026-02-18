defmodule WhatsApp.Resources.MMLiteOnboardingRequest do
  @moduledoc """
  MM Lite onboarding request details

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `request_id` | `String.t()` | Unique identifier for the MM Lite onboarding request |
  """

  @type t :: %__MODULE__{
          request_id: String.t()
        }
  @enforce_keys [:request_id]
  defstruct [
    :request_id
  ]
end
