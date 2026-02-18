defmodule WhatsApp.Resources.CreateAuthenticationTemplateWOtpCopyCodeButton do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `category` | `String.t()` |  |
  | `id` | `String.t()` |  |
  | `status` | `String.t()` |  |
  """

  @type t :: %__MODULE__{
          category: String.t() | nil,
          id: String.t() | nil,
          status: String.t() | nil
        }
  defstruct [
    :category,
    :id,
    :status
  ]
end
