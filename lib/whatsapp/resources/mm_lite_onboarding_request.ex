defmodule WhatsApp.Resources.MMLiteOnboardingRequest do
  @moduledoc """
  MM Lite onboarding request details
  """

  @type t :: %__MODULE__{
          request_id: String.t()
        }
  @enforce_keys [:request_id]
  defstruct [
    :request_id
  ]
end
