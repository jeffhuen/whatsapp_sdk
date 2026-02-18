defmodule WhatsApp.Resources.WhatsAppBusinessSolutionAccessToken do
  @moduledoc """
  Granular BISU access token response for Multi-Partner Solution partners
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
