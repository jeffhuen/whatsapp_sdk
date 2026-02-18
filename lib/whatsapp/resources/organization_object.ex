defmodule WhatsApp.Resources.OrganizationObject do
  @moduledoc false

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
