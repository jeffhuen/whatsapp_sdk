defmodule WhatsApp.Resources.OrganizationObject do
  @moduledoc """
  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `company` | `String.t()` | Company name |
  | `department` | `String.t()` | Department name |
  | `title` | `String.t()` | Job title |
  """

  @type t :: %__MODULE__{
          company: String.t() | nil,
          department: String.t() | nil,
          title: String.t() | nil
        }
  defstruct [
    :company,
    :department,
    :title
  ]
end
