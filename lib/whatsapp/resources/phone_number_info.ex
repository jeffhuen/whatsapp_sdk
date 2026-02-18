defmodule WhatsApp.Resources.PhoneNumberInfo do
  @moduledoc """
  Phone number information and status

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `code_verification_status` | `String.t()` | The two-step verification status for the phone number indicating whether the number has completed two-step verification.
  - VERIFIED: Phone number has completed two-step verification
  - UNVERIFIED: Two-step verification is pending or incomplete
   |
  | `display_phone_number` | `String.t()` | The string representation of the phone number |
  | `id` | `String.t()` | The ID associated with the phone number |
  | `name_status` | `String.t()` | The status of a display name associated with a specific phone number.
  - APPROVED: The name has been approved. You can download your certificate now.
  - AVAILABLE_WITHOUT_REVIEW: The certificate for the phone is available and display name is ready to use without review.
  - DECLINED: The name has not been approved. You cannot download your certificate.
  - EXPIRED: Your certificate has expired and can no longer be downloaded.
  - PENDING_REVIEW: Your name request is under review. You cannot download your certificate.
  - NONE: No certificate is available.
   |
  | `quality_rating` | `String.t()` | The quality rating of the phone number based on how messages have been received by recipients in recent days.
  - GREEN: High Quality
  - YELLOW: Medium Quality
  - RED: Low Quality
  - NA: Quality has not been determined
   |
  | `verified_name` | `String.t()` | The verified name associated with the phone number |

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
