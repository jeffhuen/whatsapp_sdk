defmodule WhatsApp.MultiPartnerSolutions.AcceptService do
  @moduledoc """
  APIs for managing Multi-Partner Solutions that enable collaborative WhatsApp Business
  messaging between solution owners and partner applications.

  """

  @doc """
  Accept Multi-Partner Solution Invitation

  Accept an invitation to participate in a Multi-Partner Solution as a partner application.
  This endpoint transitions the partner's status from NOTIFICATION_SENT to ACCEPTED,
  enabling the solution to progress toward ACTIVE status once all required partners accept.


  **Use Cases:**
  - Accept partnership invitations for Multi-Partner Solutions
  - Activate partner participation in existing solutions
  - Confirm partner app's commitment to solution terms and conditions
  - Enable solution workflow progression from INITIATED to ACTIVE status


  **Business Logic:**
  - Only invited partner apps can accept solution invitations
  - Solution must be in INITIATED status to accept partnerships
  - Partner status transitions from NOTIFICATION_SENT to ACCEPTED
  - Solution may become ACTIVE once all required partners accept
  - Acceptance creates formal partnership agreement between apps


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Validation:**
  - Partner app must have received a valid solution invitation
  - Solution must exist and be accessible to the partner app
  - Partner app must have proper permissions and capabilities
  - Acceptance request must include valid partner app identification


  ## Examples

  ### Minimal acceptance request

      %{"partner_app_id" => "9876543210987654"}

  ### Partner app accepting solution invitation

      %{
    "log_session_id" => "session_12345_accept_solution",
    "partner_app_id" => "9876543210987654"
  }
  """
  @spec accept_whats_app_business_solution(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessSolutionAccept.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessSolutionAccept.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def accept_whats_app_business_solution(client, solution_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{solution_id}/accept",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessSolutionAccept
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.WhatsAppBusinessSolutionAccept
         ), resp}

      error ->
        error
    end
  end
end
