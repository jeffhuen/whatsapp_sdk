defmodule WhatsApp.Resources.UrlObject do
  @moduledoc """
  ## `type` Values
  | Value |
  | --- |
  | `HOME` |
  | `WORK` |
  """

  @type t :: %__MODULE__{
          type: String.t() | nil,
          url: String.t()
        }
  @enforce_keys [:url]
  defstruct [
    :type,
    :url
  ]
end
