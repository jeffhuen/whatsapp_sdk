defmodule WhatsApp.Resources.SectionObject do
  @moduledoc """
  A section object, used in List Messages and Multi-Product Messages.

  ## `product_items` Constraints

  - Minimum items: 1
  - Maximum items: 30

  ## `rows` Constraints

  - Maximum items: 10

  ## `title` Constraints

  - Maximum length: 24
  """

  @type t :: %__MODULE__{
          product_items: list(map()) | nil,
          rows: list(map()) | nil,
          title: String.t() | nil
        }
  defstruct [
    :product_items,
    :rows,
    :title
  ]
end
