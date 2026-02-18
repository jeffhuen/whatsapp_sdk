defmodule WhatsApp.WhatsappBusinessProfiles.RootService do
  @moduledoc """
  APIs for managing WhatsApp Business Profile details and configuration
  """

  @doc """
  Get WhatsApp Business Profile Details

  Retrieve comprehensive details about a WhatsApp Business Profile, including business information,
  contact details, and profile configuration.


  **Use Cases:**
  - Retrieve business profile information and metadata
  - Verify profile configuration and contact details
  - Check profile status and business information
  - Validate profile state before business operations


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Profile details can be cached for moderate periods, but business information may change
  occasionally. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id and any available profile fields).
  Available fields: id, account_name, description, email, about, address, vertical, websites, profile_picture_url, messaging_product

  """
  @spec get_whats_app_business_profile_details(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessProfileNode.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessProfileNode.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_whats_app_business_profile_details(client, whatsapp_business_profile_id, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{whatsapp_business_profile_id}",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessProfileNode)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessProfileNode),
         resp}

      error ->
        error
    end
  end

  @doc """
  Update WhatsApp Business Profile

  Update the WhatsApp Business Profile information such as business description, email, address,
  and other profile details. This operation corresponds to the GraphWhatsAppBusinessProfilePost functionality.


  **Use Cases:**
  - Update business profile information and metadata
  - Modify contact details and business description
  - Change business vertical classification
  - Update website URLs and profile picture
  - Maintain current business profile information


  **Profile Picture Upload:**
  It is recommended to use the Resumable Upload API to obtain an upload ID, then use this
  upload ID to obtain the picture handle for the `profile_picture_handle` field.


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  ## Examples

  ### Complete profile update with all fields

      %{
    "about" => "Premium products delivered worldwide with excellent service",
    "account_name" => "Updated E-commerce Business",
    "address" => "456 Updated Business Avenue, Commerce City, CC 54321",
    "description" => "Updated leading e-commerce platform for premium products",
    "email" => "updated-contact@business-example.com",
    "messaging_product" => "whatsapp",
    "profile_picture_handle" => "4:VGVzdC5wbmc=:aW1hZ2UvanBlZw==:ARat4Mt-L09JON3f30SmDkdyPSuyBkDDYiB4TFXuXISjdgHoNp2b7j882_9Jzr2tPrdKxi92UygyVzTivJiOvmebMpZ6MIjTik3gTyI3ZCQAgQ:e:1659995302:2022308451254161:636685196:ARZf1ftR5N6-qSLtklU",
    "vertical" => "RETAIL",
    "websites" => ["https://www.updated-business-example.com",
     "https://shop.updated-business-example.com"]
  }

  ### Minimal profile update with required fields only

      %{
    "description" => "Updated customer service business",
    "email" => "updated-support@service-example.com",
    "messaging_product" => "whatsapp"
  }
  """
  @spec update_whats_app_business_profile(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessProfileUpdate.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessProfileUpdate.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def update_whats_app_business_profile(client, whatsapp_business_profile_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{whatsapp_business_profile_id}",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessProfileUpdate)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessProfileUpdate
         ), resp}

      error ->
        error
    end
  end
end
