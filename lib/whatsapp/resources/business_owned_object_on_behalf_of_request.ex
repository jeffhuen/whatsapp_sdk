defmodule WhatsApp.Resources.BusinessOwnedObjectOnBehalfOfRequest do
  @moduledoc """
  On-behalf request details for business owned objects

  ## `status` Values
  | Value |
  | --- |
  | `APPROVE` |
  | `DECLINE` |
  | `IN_PROGRESS` |
  | `EXPIRED` |
  | `PENDING` |
  | `CANCELED` |
  | `INVALID` |
  """

  @type t :: %__MODULE__{
          business_owned_object: String.t(),
          id: String.t(),
          receiving_business: map() | nil,
          requesting_business: map() | nil,
          status: String.t()
        }
  @enforce_keys [:id, :status, :business_owned_object]
  defstruct [
    :business_owned_object,
    :id,
    :receiving_business,
    :requesting_business,
    :status
  ]
end
