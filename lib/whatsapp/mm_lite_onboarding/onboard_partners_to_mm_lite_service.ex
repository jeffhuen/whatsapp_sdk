defmodule WhatsApp.MmLiteOnboarding.OnboardPartnersToMmLiteService do
  @moduledoc """
  APIs for managing Multi-Partner MM Lite onboarding requests and business agreements
  """

  @doc """
  Onboard Partners to MM Lite

  Send a request from the partner to onboard an end business to MM Lite.
  This creates a business agreement request and sets OBO mobility intents
  on eligible WhatsApp Business Accounts.


  **Business Flow:**
  1. Validates partner business and app permissions
  2. Checks end business eligibility for MM Lite
  3. Identifies eligible shared WABAs and OBO WABAs
  4. Sets mobility intents on eligible OBO WABAs (BSPs only)
  5. Creates business agreement request
  6. Returns request ID for tracking


  **BSP vs TP Behavior:**
  - BSPs (Business Solution Providers): Can create OBO WABAs and set mobility intents
  - TPs (Technology Partners): Can only create onboarding requests, no OBO WABA management


  **Rate Limiting:**
  Subject to business partner integrations use case throttling limits.
  Use appropriate retry logic with exponential backoff.


  **Idempotency:**
  If a pending request already exists between the same partner and end business,
  the existing request ID is returned instead of creating a duplicate.


  ## Parameters

    - `solution_id` (string, optional) - Optional WhatsApp Business Solution ID to associate with the onboarding request.
  If provided, the solution will be linked to the business agreement and OBO mobility intents.

  """
  @spec onboard_partners_to_mm_lite(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.MMLiteOnboardingRequest.t()}
          | {:ok, WhatsApp.Resources.MMLiteOnboardingRequest.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def onboard_partners_to_mm_lite(client, business_id, opts \\ []) do
    query_params =
      [{:solution_id, Keyword.get(opts, :solution_id)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{business_id}/onboard_partners_to_mm_lite",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.MMLiteOnboardingRequest)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.MMLiteOnboardingRequest),
         resp}

      error ->
        error
    end
  end
end
