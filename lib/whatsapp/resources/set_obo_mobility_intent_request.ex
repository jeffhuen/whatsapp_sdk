defmodule WhatsApp.Resources.SetOBOMobilityIntentRequest do
  @moduledoc """
  Request payload for setting OBO mobility intent

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `actor_id` | `String.t()` | Actor ID performing the OBO mobility intent operation |
  | `app_id` | `String.t()` | Application ID requesting OBO mobility intent |
  | `client_mutation_id` | `String.t()` | Client-provided mutation identifier for request tracking |
  | `solution_id` | `String.t()` | Unique identifier for the Multi-Partner Solution |
  | `waba_id` | `String.t()` | WhatsApp Business Account ID for which to set OBO mobility intent |

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
