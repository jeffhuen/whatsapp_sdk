defmodule WhatsApp.Resources.SetOBOMobilityIntent do
  @moduledoc """
  Response for setting OBO mobility intent
  """

  @type t :: %__MODULE__{
          client_mutation_id: String.t() | nil,
          error_msg: String.t() | nil,
          intent_id: String.t() | nil,
          success: boolean()
        }
  @enforce_keys [:success]
  defstruct [
    :client_mutation_id,
    :error_msg,
    :intent_id,
    :success
  ]
end
