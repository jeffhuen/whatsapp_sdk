defmodule WhatsApp.Resources.SipServerInfo do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `app_id` | `String.t()` | Application ID for SIP server |
  | `hostname` | `String.t()` | SIP server hostname |
  | `password` | `String.t()` | SIP password (only included when include_sip_credentials=true) |
  | `port` | `integer()` | SIP server port (optional) |
  """

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
