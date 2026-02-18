defmodule WhatsApp.Resources.CallingSettings1 do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `call_icon_visibility` | `String.t()` | Control visibility of the call icon |
  | `sip` | `map()` |  |
  | `srtp_key_exchange_protocol` | `String.t()` | SRTP key exchange protocol |
  | `status` | `String.t()` | Enable or disable calling feature |
  | `video` | `map()` |  |

  ## `call_icon_visibility` Values
  | Value |
  | --- |
  | `visible` |
  | `hidden` |

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
          call_icon_visibility: String.t() | nil,
          sip: map() | nil,
          srtp_key_exchange_protocol: String.t() | nil,
          status: String.t(),
          video: map() | nil
        }
  @enforce_keys [:status]
  defstruct [
    :call_icon_visibility,
    :sip,
    :srtp_key_exchange_protocol,
    :status,
    :video
  ]
end
