defmodule WhatsApp.Resources.SipServerInfo do
  @moduledoc false

  @type t :: %__MODULE__{
          app_id: String.t(),
          hostname: String.t(),
          password: String.t() | nil,
          port: integer() | nil
        }
  @enforce_keys [:app_id, :hostname]
  defstruct [
    :app_id,
    :hostname,
    :password,
    :port
  ]
end
