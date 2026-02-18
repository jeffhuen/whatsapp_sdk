defmodule WhatsApp.Resources.OfficialBusinessAccountUpdateRequest do
  @moduledoc """
  Request payload for updating Official Business Account status

  ## Fields
  | Field | Type | Description |
  | --- | --- | --- |
  | `additional_supporting_information` | `String.t()` | Additional information to support the Official Business Account application |
  | `business_website_url` | `String.t()` | Official business website URL |
  | `parent_business_or_brand` | `String.t()` | Parent business or brand name |
  | `primary_country_of_operation` | `String.t()` | Primary country where the business operates |
  | `primary_language` | `String.t()` | Primary language used by the business |
  | `supporting_links` | `list()` | Supporting links that demonstrate business notability (minimum 5, maximum 10) |

  ## `additional_supporting_information` Constraints

  - Maximum length: 1000

  ## `parent_business_or_brand` Constraints

  - Maximum length: 255

  ## `supporting_links` Constraints

  - Minimum items: 5
  - Maximum items: 10
  """

  @type t :: %__MODULE__{
          additional_supporting_information: String.t() | nil,
          business_website_url: String.t(),
          parent_business_or_brand: String.t() | nil,
          primary_country_of_operation: String.t(),
          primary_language: String.t() | nil,
          supporting_links: list(String.t()) | nil
        }
  @enforce_keys [:business_website_url, :primary_country_of_operation]
  defstruct [
    :additional_supporting_information,
    :business_website_url,
    :parent_business_or_brand,
    :primary_country_of_operation,
    :primary_language,
    :supporting_links
  ]
end
