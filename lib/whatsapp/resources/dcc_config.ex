defmodule WhatsApp.Resources.DCCConfig do
  @moduledoc """
  Data and Content Control configuration
  """

  @type t :: %__MODULE__{
          enabled: boolean() | nil,
          policy_url: String.t() | nil
        }
  defstruct [
    :enabled,
    :policy_url
  ]
end
