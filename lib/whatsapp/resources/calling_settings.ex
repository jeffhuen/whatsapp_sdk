defmodule WhatsApp.Resources.CallingSettings do
  @moduledoc """
  ## `call_icon_visibility` Values
  | Value |
  | --- |
  | `visible` |
  | `hidden` |

  ## `callback_permission_status` Values
  | Value |
  | --- |
  | `enabled` |
  | `disabled` |

  ## `srtp_key_exchange_protocol` Values
  | Value |
  | --- |
  | `DTLS-SRTP` |
  | `SDES-SRTP` |

  ## `status` Values
  | Value |
  | --- |
  | `enabled` |
  | `disabled` |
  """

  @type t :: %__MODULE__{
          audio: map() | nil,
          call_hours: map() | nil,
          call_icon_visibility: String.t(),
          call_icons: map() | nil,
          callback_permission_status: String.t(),
          ip_addresses: map(),
          restrictions: map() | nil,
          sip: map() | nil,
          srtp_key_exchange_protocol: String.t() | nil,
          status: String.t(),
          video: map() | nil
        }
  @enforce_keys [:status, :call_icon_visibility, :ip_addresses, :callback_permission_status]
  defstruct [
    :audio,
    :call_hours,
    :call_icon_visibility,
    :call_icons,
    :callback_permission_status,
    :ip_addresses,
    :restrictions,
    :sip,
    :srtp_key_exchange_protocol,
    :status,
    :video
  ]
end
