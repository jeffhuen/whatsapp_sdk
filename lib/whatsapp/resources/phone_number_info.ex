defmodule WhatsApp.Resources.PhoneNumberInfo do
  @moduledoc """
  Phone number information and status

  ## `code_verification_status` Values
  | Value |
  | --- |
  | `VERIFIED` |
  | `UNVERIFIED` |

  ## `name_status` Values
  | Value |
  | --- |
  | `APPROVED` |
  | `AVAILABLE_WITHOUT_REVIEW` |
  | `DECLINED` |
  | `EXPIRED` |
  | `PENDING_REVIEW` |
  | `NONE` |

  ## `quality_rating` Values
  | Value |
  | --- |
  | `GREEN` |
  | `YELLOW` |
  | `RED` |
  | `NA` |
  """

  @type t :: %__MODULE__{
          code_verification_status: String.t() | nil,
          display_phone_number: String.t() | nil,
          id: String.t() | nil,
          name_status: String.t() | nil,
          quality_rating: String.t() | nil,
          verified_name: String.t() | nil
        }
  defstruct [
    :code_verification_status,
    :display_phone_number,
    :id,
    :name_status,
    :quality_rating,
    :verified_name
  ]
end
