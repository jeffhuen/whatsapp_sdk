defmodule WhatsApp.MultiPartnerSolutions.SendDeactivationRequestService do
  @moduledoc """
  APIs for managing Multi-Partner Solutions that enable collaborative WhatsApp Business
  messaging between solution owners and partner applications.

  """

  @doc """
  Send Multi-Partner Solution Deactivation Request

  Submit a deactivation request for a Multi-Partner Solution. This initiates
  a workflow to transition the solution from its current state to deactivated,
  following proper business validation and approval processes.


  **Use Cases:**
  - Request deactivation of an active Multi-Partner Solution
  - Initiate solution lifecycle transition management
  - Trigger business workflow for solution deactivation approval
  - Programmatically manage solution lifecycle states


  **Business Logic:**
  - Solution must be in ACTIVE or INITIATED state to be eligible for deactivation
  - Deactivation requests are processed asynchronously
  - Solution status will transition to PENDING_DEACTIVATION during processing
  - Final deactivation requires business approval workflow completion


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Workflow:**
  1. Validate solution ownership and permissions
  2. Check solution eligibility for deactivation
  3. Submit deactivation request to business workflow
  4. Return confirmation with tracking identifier


  ## Examples

  ### Deactivation request with reason

      %{"reason" => "Solution no longer needed for current business operations"}

  ### Deactivation request without reason

      %{}
  """
  @spec send_solution_deactivation_request(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessSolutionDeactivation.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessSolutionDeactivation.t(),
             WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def send_solution_deactivation_request(client, solution_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{solution_id}/send_deactivation_request",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessSolutionDeactivation
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessSolutionDeactivation
         ), resp}

      error ->
        error
    end
  end
end
