defmodule WhatsApp.OfficialBusinessAccount.OfficialBusinessAccountService do
  @moduledoc """
  APIs for managing Official Business Account status and verification
  """

  @doc """
  Get Official Business Account Status

  Retrieve the Official Business Account (OBA) status and related information for a WhatsApp Business Account phone number.

  **Use Cases:**
  - Check current OBA verification status
  - Monitor OBA application progress
  - Retrieve status messages for business account verification
  - Validate business credibility status

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Caching:**
  OBA status information can be cached for moderate periods, but status may change
  during verification processes. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (oba_status, status_message).
  Available fields: oba_status, status_message

  """
  @spec get_official_business_account_status(WhatsApp.Client.t(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def get_official_business_account_status(client, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    WhatsApp.Client.request(
      client,
      :get,
      "/#{client.api_version}/#{phone_number_id}/official_business_account",
      [params: query_params] ++ opts
    )
  end

  @doc """
  Update Official Business Account Status

  Update or modify the Official Business Account (OBA) status for a WhatsApp Business Account phone number.
  This endpoint allows businesses to submit new applications, withdraw existing applications, or resubmit
  after addressing rejection reasons.

  **Use Cases:**
  - Submit initial Official Business Account application
  - Withdraw pending OBA application
  - Resubmit OBA application after addressing rejection feedback
  - Update application data for pending applications

  **Application Data Requirements:**
  When submitting or resubmitting an OBA application, certain business information may be required
  depending on the current status and previous submissions.

  **Rate Limiting:**
  Standard Graph API rate limits apply with additional restrictions on application submissions
  to prevent abuse. Use appropriate retry logic with exponential backoff.

  **Status Transitions:**
  - Applications can only be submitted when no active application exists
  - Withdrawals are only allowed for pending applications
  - Resubmissions are only allowed after rejection


  ## Examples

  ### Resubmit after rejection

      %{
    "action" => "RESUBMIT_APPLICATION",
    "application_data" => %{
      "business_description" => "Updated business description addressing previous feedback",
      "business_name" => "Acme Corporation Ltd",
      "contact_email" => "business@acmecorp.com",
      "website_url" => "https://www.acmecorp.com"
    }
  }

  ### Submit new OBA application

      %{
    "action" => "SUBMIT_APPLICATION",
    "application_data" => %{
      "business_description" => "Leading provider of innovative business solutions and consulting services",
      "business_name" => "Acme Corporation Ltd",
      "contact_email" => "business@acmecorp.com",
      "website_url" => "https://www.acmecorp.com"
    }
  }

  ### Withdraw pending application

      %{"action" => "WITHDRAW_APPLICATION"}
  """
  @spec graph_whats_app_business_account_to_number_current_status_official_business_account_post(
          WhatsApp.Client.t(),
          map(),
          keyword()
        ) ::
          {:ok, WhatsApp.Resources.OfficialBusinessAccountUpdate.t()}
          | {:ok, WhatsApp.Resources.OfficialBusinessAccountUpdate.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def graph_whats_app_business_account_to_number_current_status_official_business_account_post(
        client,
        params,
        opts \\ []
      ) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/official_business_account",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.OfficialBusinessAccountUpdate)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.OfficialBusinessAccountUpdate
         ), resp}

      error ->
        error
    end
  end
end
