defmodule WhatsApp.CommerceSettings.WhatsappCommerceSettingsService do
  @moduledoc false

  @doc """
  Get commerce settings

  - Guide: [Sell Products & Services](https://developers.facebook.com/docs/business-messaging/whatsapp/catalogs/sell-products-and-services) (Cloud API)
  - Guide: [Sell Products & Services](https://developers.facebook.com/docs/whatsapp/on-premises/guides/commerce-guides) (On-Premises API)
  - Endpoint reference: [WhatsApp Business Phone Number > WhatsApp Commerce Settings](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-account-to-number-current-status/whatsapp_commerce_settings)
  """
  @spec get_commerce_settings(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def get_commerce_settings(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    WhatsApp.Client.request(
      client,
      :get,
      "/#{client.api_version}/#{phone_number_id}/whatsapp_commerce_settings",
      opts
    )
  end

  @doc """
  Set or update commerce settings

  - Guide: [Sell Products & Services](https://developers.facebook.com/docs/business-messaging/whatsapp/catalogs/sell-products-and-services) (Cloud API)
  - Guide: [Sell Products & Services](https://developers.facebook.com/docs/whatsapp/on-premises/guides/commerce-guides) (On-Premises API)
  - Endpoint reference: [WhatsApp Business Phone Number > WhatsApp Commerce Settings](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-account-to-number-current-status/whatsapp_commerce_settings)

  ## Parameters

    - `is_cart_enabled` (string, optional) - 
    - `is_catalog_visible` (string, optional) - 
  """
  @spec set_or_update_commerce_settings(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Resources.SetOrUpdateCommerceSettings.t()}
          | {:ok, WhatsApp.Resources.SetOrUpdateCommerceSettings.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def set_or_update_commerce_settings(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [
        {:is_cart_enabled, Keyword.get(opts, :is_cart_enabled)},
        {:is_catalog_visible, Keyword.get(opts, :is_catalog_visible)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/whatsapp_commerce_settings",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.SetOrUpdateCommerceSettings)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.SetOrUpdateCommerceSettings),
         resp}

      error ->
        error
    end
  end
end
