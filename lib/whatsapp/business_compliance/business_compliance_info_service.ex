defmodule WhatsApp.BusinessCompliance.BusinessComplianceInfoService do
  @moduledoc """
  APIs for retrieving WhatsApp Business Account compliance information
  """

  @doc """
  Get Business Compliance Information

  Retrieve comprehensive business compliance information for a WhatsApp Business Account phone number,
  including entity details, registration status, and required contact information for regulatory compliance.


  **Use Cases:**
  - Retrieve business compliance information for regulatory reporting
  - Verify business entity registration status and contact details
  - Access grievance officer and customer care information
  - Support compliance audits and regulatory verification processes


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Compliance information can be cached for moderate periods, but should be refreshed regularly
  to ensure accuracy for regulatory purposes. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned. Available fields: messaging_product, entity_name,
  entity_type, entity_type_custom, is_registered, grievance_officer_details, customer_care_details

  """
  @spec get_business_compliance_info(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_business_compliance_info(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{phone_number_id}/business_compliance_info",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.BusinessComplianceInfo)
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.BusinessComplianceInfo)
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `get_business_compliance_info/2` that auto-pages through all results."
  @spec stream_business_compliance_info(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_business_compliance_info(client, opts \\ []) do
    case get_business_compliance_info(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn:
            &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.BusinessComplianceInfo)
        )

      error ->
        error
    end
  end

  @doc """
  Update Business Compliance Information

  Create or update comprehensive business compliance information for a WhatsApp Business Account phone number,
  including entity details, registration status, and required contact information for regulatory compliance.


  **Use Cases:**
  - Set business compliance information for regulatory reporting
  - Update business entity registration status and details
  - Configure grievance officer and customer care contact information
  - Ensure compliance data accuracy for regulatory purposes
  - Support compliance setup for new business operations


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Validation Rules:**
  - `entity_name` is required and must be between 2 and 128 characters
  - `entity_type` is required and must be a valid entity type enum value
  - `entity_type_custom` is mandatory when `entity_type` is "Other"
  - `entity_type_custom` cannot be used with non-"Other" entity types
  - `is_registered` can only be used with "Other" or "Partnership" entity types
  - `grievance_officer_details` is required with complete contact information
  - `customer_care_details` is required with contact information
  - Phone numbers must be valid international format with country code
  - Email addresses must be valid format and under 128 characters


  ## Examples

  ### Complete compliance information update

      %{
    "customer_care_details" => %{
      "email" => "support@luckyshrub.com",
      "landline_number" => "+913857614343",
      "mobile_number" => "+913854559033"
    },
    "entity_name" => "Lucky Shrub Private Limited",
    "entity_type" => "PARTNERSHIP",
    "grievance_officer_details" => %{
      "email" => "chandravati@luckyshrub.com",
      "landline_number" => "+913857614343",
      "mobile_number" => "+913854559033",
      "name" => "Chandravati P."
    },
    "is_registered" => true,
    "messaging_product" => "whatsapp"
  }

  ### Custom entity type compliance information

      %{
    "customer_care_details" => %{
      "email" => "support@innovativetech.com",
      "mobile_number" => "+918901234567"
    },
    "entity_name" => "Innovative Tech Solutions",
    "entity_type" => "OTHER",
    "entity_type_custom" => "Limited Liability Partnership",
    "grievance_officer_details" => %{
      "email" => "rajesh@innovativetech.com",
      "mobile_number" => "+918901234567",
      "name" => "Rajesh Kumar"
    },
    "is_registered" => true,
    "messaging_product" => "whatsapp"
  }
  """
  @spec update_business_compliance_info(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.UpdateBusinessComplianceInfo.t()}
          | {:ok, WhatsApp.Resources.UpdateBusinessComplianceInfo.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def update_business_compliance_info(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/business_compliance_info",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UpdateBusinessComplianceInfo)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.UpdateBusinessComplianceInfo),
         resp}

      error ->
        error
    end
  end
end
