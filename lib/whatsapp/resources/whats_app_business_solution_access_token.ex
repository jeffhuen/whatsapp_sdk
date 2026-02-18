defmodule WhatsApp.Resources.WhatsAppBusinessSolutionAccessToken do
  @moduledoc """
  Granular BISU access token response for Multi-Partner Solution partners

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `access_token` | `String.t()` | Granular BISU access token for accessing customer business resources |
  | `expires_at` | `integer()` | Unix timestamp indicating when the access token expires |
  """

  @type t :: %__MODULE__{
          access_token: String.t(),
          expires_at: integer()
        }
  @enforce_keys [:access_token, :expires_at]
  defstruct [
    :access_token,
    :expires_at
  ]
end
