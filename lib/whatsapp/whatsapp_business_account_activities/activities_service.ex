defmodule WhatsApp.WhatsappBusinessAccountActivities.ActivitiesService do
  @moduledoc """
  APIs for retrieving WhatsApp Business Account activity logs and audit trails
  """

  @doc """
  Get WhatsApp Business Account Activities

  Retrieve activity logs and audit trails for a WhatsApp Business Account.
  This endpoint returns a chronological list of activities performed on the account,
  including administrative actions, configuration changes, and operational events.

  **Use Cases:**
  - Monitor account configuration changes and administrative actions
  - Generate compliance and audit reports for regulatory requirements
  - Track user activities and permission modifications
  - Investigate security incidents and unauthorized access attempts
  - Monitor API usage patterns and operational events

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Caching:**
  Activity data can be cached for short periods, but recent activities may change
  frequently. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, activity_type, timestamp, actor_type).
  Available fields: id, activity_type, timestamp, actor_type, actor_id, actor_name, description, details, ip_address, user_agent

    - `limit` (integer, optional) - Maximum number of activity records to return per page. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use this to get the next page of results.

    - `before` (string, optional) - Cursor for pagination. Use this to get the previous page of results.

    - `since` (string, optional) - Unix timestamp or ISO 8601 date string. Only return activities that occurred after this time.

    - `until` (string, optional) - Unix timestamp or ISO 8601 date string. Only return activities that occurred before this time.

    - `activity_type` (string, optional) - Filter activities by type. Can be a single type or comma-separated list of types.

  """
  @spec get_whats_app_business_account_activities(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_whats_app_business_account_activities(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)},
        {:since, Keyword.get(opts, :since)},
        {:until, Keyword.get(opts, :until)},
        {:activity_type, Keyword.get(opts, :activity_type)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{waba_id}/activities",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.WhatsAppBusinessAccountActivity
           )
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.WhatsAppBusinessAccountActivity
           )
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `get_whats_app_business_account_activities/2` that auto-pages through all results."
  @spec stream_whats_app_business_account_activities(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_whats_app_business_account_activities(client, opts \\ []) do
    case get_whats_app_business_account_activities(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn:
            &WhatsApp.Deserializer.deserialize(
              &1,
              WhatsApp.Resources.WhatsAppBusinessAccountActivity
            )
        )

      error ->
        error
    end
  end
end
