defmodule WhatsApp.Resources.SetOBOMobilityIntentRequest do
  @moduledoc """
  Request payload for setting OBO mobility intent

  ## `actor_id` Constraints

  - Pattern: `^[0-9]+$`

  ## `app_id` Constraints

  - Pattern: `^[0-9]+$`

  ## `client_mutation_id` Constraints

  - Maximum length: 255

  ## `solution_id` Constraints

  - Pattern: `^[0-9]+$`

  ## `waba_id` Constraints

  - Pattern: `^[0-9]+$`
  """

  @type t :: %__MODULE__{
          actor_id: String.t() | nil,
          app_id: String.t() | nil,
          client_mutation_id: String.t() | nil,
          solution_id: String.t() | nil,
          waba_id: String.t()
        }
  @enforce_keys [:waba_id]
  defstruct [
    :actor_id,
    :app_id,
    :client_mutation_id,
    :solution_id,
    :waba_id
  ]
end
