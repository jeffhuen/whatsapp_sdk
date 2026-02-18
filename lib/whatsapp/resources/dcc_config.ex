defmodule WhatsApp.Resources.DCCConfig do
  @moduledoc """
  Data and Content Control configuration

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `enabled` | `boolean()` | Whether DCC is enabled |
  | `policy_url` | `String.t()` | URL to the DCC policy |
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
