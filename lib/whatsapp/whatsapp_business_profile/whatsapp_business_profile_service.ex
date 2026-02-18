defmodule WhatsApp.WhatsappBusinessProfile.WhatsappBusinessProfileService do
  @moduledoc """
  APIs for managing WhatsApp Business Profile information and settings
  """

  @doc """
  Get WhatsApp Business Profile

  Retrieve comprehensive information about a WhatsApp Business Profile, including
  business details, contact information, and profile settings.


  **Use Cases:**
  - Retrieve current business profile information
  - Check business contact details and settings
  - Verify business vertical and website information
  - Get profile picture URL and about section


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Business profile information can be cached for moderate periods, but should be
  refreshed periodically to ensure accuracy.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (messaging_product, about, address, description, email, profile_picture_url, websites, vertical).
  Available fields: messaging_product, about, address, description, email, profile_picture_url, websites, vertical

  """
  @spec get_whats_app_business_profile(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def get_whats_app_business_profile(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    WhatsApp.Client.request(
      client,
      :get,
      "/#{client.api_version}/#{phone_number_id}/whatsapp_business_profile",
      [params: query_params] ++ opts
    )
  end

  @doc """
  Update WhatsApp Business Profile

  Update WhatsApp Business Profile information including business details,
  contact information, and profile settings.


  **Use Cases:**
  - Update business description and contact information
  - Modify business address and website information
  - Change business vertical classification
  - Update profile picture using Resumable Upload API
  - Update profile picture and about section


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Profile Picture Updates:**
  To update the profile picture, first use the Resumable Upload API to obtain a
  profile_picture_handle, then include it in the request.


  ## Examples

  ### Complete business profile update

      %{
    "about" => "Welcome to our business! We provide excellent service.",
    "address" => "123 Business Street, City, State 12345",
    "description" => "We are a leading provider of quality products and services.",
    "email" => "contact@business.com",
    "messaging_product" => "whatsapp",
    "profile_picture_handle" => "4:VGVzdC5wbmc=:aW1hZ2UvanBlZw==:ARat4Mt-L09JON3f30SmDkdyPSuyBkDDYiB4TFXuXISjdgHoNp2b7j882_9Jzr2tPrdKxi92UygyVzTivJiOvmebMpZ6MIjTik3gTyI3ZCQAgQ:e:1659995302:2022308451254161:636685196:ARZf1ftR5N6-qSLtklU",
    "vertical" => "RESTAURANT",
    "websites" => ["https://www.business.com",
     "https://www.facebook.com/business"]
  }

  ### Minimal business profile update

      %{
    "description" => "Updated business description",
    "messaging_product" => "whatsapp"
  }
  """
  @spec update_whats_app_business_profile_information(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessProfileUpdate.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessProfileUpdate.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def update_whats_app_business_profile_information(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/whatsapp_business_profile",
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
