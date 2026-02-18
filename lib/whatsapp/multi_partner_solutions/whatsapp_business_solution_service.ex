defmodule WhatsApp.MultiPartnerSolutions.WhatsappBusinessSolutionService do
  @moduledoc """
  APIs for managing Multi-Partner Solutions that enable collaborative WhatsApp Business
  messaging between solution owners and partner applications.

  """

  @doc """
  Create Multi-Partner Solution

  Create a new Multi-Partner Solution that defines permission distribution between
  a solution owner app and a partner app for WhatsApp Business messaging collaboration.


  **Permission Logic:**
  - Only one partner (owner or partner app) can have MESSAGING permission
  - At least one partner must have MESSAGING permission
  - Both partners automatically receive default solution partner permissions
  - Empty permission arrays indicate no configurable permissions for that partner


  **Solution Lifecycle:**
  - Solutions are created with INITIATED status
  - Require subsequent activation workflow through solution management
  - Can be managed through Partner Dashboard or solution management APIs


  **Rate Limiting:**
  Standard Graph API rate limits apply with WhatsApp Business Management throttling.
  Use appropriate retry logic with exponential backoff for rate-limited requests.


  **Validation:**
  - Partner app must be accessible and have proper capabilities
  - Permission combinations are validated against business logic rules
  - Solution names must meet length and content requirements


  ## Examples

  ### Owner app has messaging permission

      %{
    "owner_permissions" => ["MESSAGING"],
    "partner_app_id" => "9876543210987654",
    "partner_permissions" => [],
    "solution_name" => "Owner-Managed Messaging Solution"
  }

  ### Partner app has messaging permission

      %{
    "owner_permissions" => [],
    "partner_app_id" => "9876543210987654",
    "partner_permissions" => ["MESSAGING"],
    "solution_name" => "Partner-Managed Messaging Solution"
  }
  """
  @spec create_whats_app_business_solution(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessSolutionCreate.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessSolutionCreate.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def create_whats_app_business_solution(client, application_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{application_id}/whatsapp_business_solution",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessSolutionCreate
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessSolutionCreate
         ), resp}

      error ->
        error
    end
  end
end
