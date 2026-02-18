defmodule WhatsApp.WebhookSubscriptions.SubscribedAppsService do
  @moduledoc """
  APIs for managing WhatsApp Business Account webhook subscriptions
  """

  @doc """
  Get All Subscriptions for a WABA

  Retrieve a list of all applications currently subscribed to webhook events
  for the specified WhatsApp Business Account.


  **Use Cases:**
  - Monitor which apps are subscribed to WABA webhook events
  - Audit subscription configurations and permissions
  - Verify subscription status before making changes
  - Retrieve subscription details for troubleshooting


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Subscription data can be cached for short periods, but may change when apps
  subscribe or unsubscribe. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned. Available fields: id, name, link

  """
  @spec get_all_subscriptions_for_a_waba(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_all_subscriptions_for_a_waba(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{waba_id}/subscribed_apps",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.SubscribedApp)
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.SubscribedApp)
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `get_all_subscriptions_for_a_waba/2` that auto-pages through all results."
  @spec stream_all_subscriptions_for_a_waba(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_all_subscriptions_for_a_waba(client, opts \\ []) do
    case get_all_subscriptions_for_a_waba(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn: &WhatsApp.Deserializer.deserialize(&1, WhatsApp.Resources.SubscribedApp)
        )

      error ->
        error
    end
  end

  @doc """
  Subscribe to WABA Webhooks

  Subscribe your application to webhook events for the specified WhatsApp Business Account.
  This enables your app to receive real-time notifications for events such as message
  deliveries, status updates, and other WABA activities.


  **Use Cases:**
  - Enable webhook notifications for your app
  - Configure custom callback URLs for webhook delivery
  - Set up webhook verification tokens for security
  - Override default app webhook settings for specific WABAs


  **Rate Limiting:**
  Standard Graph API rate limits apply. Subscription operations may have additional
  throttling to prevent abuse.


  **Security:**
  Always use HTTPS endpoints for webhook callbacks. Verify webhook authenticity
  using the provided verification tokens and signature validation.


  ## Examples

  ### Basic subscription without custom configuration

      %{}

  ### Subscription with custom callback URL

      %{
    "override_callback_uri" => "https://your-webhook-endpoint.com/webhook",
    "verify_token" => "YOUR_VERIFY_TOKEN_PLACEHOLDER"
  }
  """
  @spec subscribe_to_waba_webhooks(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.Subscription.t()}
          | {:ok, WhatsApp.Resources.Subscription.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def subscribe_to_waba_webhooks(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}/subscribed_apps",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Subscription)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Subscription), resp}

      error ->
        error
    end
  end

  @doc """
  Unsubscribe from WABA Webhooks

  Unsubscribe your application from webhook events for the specified WhatsApp Business Account.
  This will stop your app from receiving webhook notifications for this WABA.


  **Use Cases:**
  - Disable webhook notifications when no longer needed
  - Clean up subscriptions during app decommissioning
  - Temporarily disable webhooks for maintenance
  - Remove subscriptions for WABAs no longer managed by your app


  **Rate Limiting:**
  Standard Graph API rate limits apply. Unsubscription operations are typically
  processed immediately.


  **Important:**
  Unsubscribing will immediately stop all webhook deliveries for this WABA.
  Ensure your application can handle the cessation of webhook events gracefully.

  """
  @spec unsubscribe_from_waba_webhooks(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Resources.Subscription.t()}
          | {:ok, WhatsApp.Resources.Subscription.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def unsubscribe_from_waba_webhooks(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :delete,
           "/#{client.api_version}/#{waba_id}/subscribed_apps",
           opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Subscription)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Subscription), resp}

      error ->
        error
    end
  end
end
