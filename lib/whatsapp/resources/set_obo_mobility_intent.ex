defmodule WhatsApp.Resources.SetOBOMobilityIntent do
  @moduledoc """
  Response for setting OBO mobility intent

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `client_mutation_id` | `String.t()` | Client-provided mutation identifier echoed back |
  | `error_msg` | `String.t()` | Error message if the operation failed |
  | `intent_id` | `String.t()` | Unique identifier for the created OBO mobility intent |
  | `success` | `boolean()` | Indicates if the OBO mobility intent was set successfully |
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
