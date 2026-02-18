defmodule WhatsApp.Resources.OBOMobilityIntentNode do
  @moduledoc """
  WhatsApp Business Account OBO Mobility Intent Node

  ## `status` Values
  | Value |
  | --- |
  | `PENDING` |
  | `ACTIVE` |
  | `COMPLETED` |
  | `CANCELLED` |
  | `FAILED` |
  """

  @type t :: %__MODULE__{
          created_time: DateTime.t() | nil,
          id: String.t(),
          solution: map(),
          status: String.t() | nil,
          updated_time: DateTime.t() | nil,
          waba: map()
        }
  @enforce_keys [:id, :waba, :solution]
  defstruct [
    :created_time,
    :id,
    :solution,
    :status,
    :updated_time,
    :waba
  ]
end
