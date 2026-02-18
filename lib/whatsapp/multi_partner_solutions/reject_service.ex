defmodule WhatsApp.MultiPartnerSolutions.RejectService do
  @moduledoc """
  APIs for managing Multi-Partner Solutions that enable collaborative WhatsApp Business
  messaging between solution owners and partner applications.

  """

  @doc """
  Reject Multi-Partner Solution Request

  Reject a pending partnership request or deactivation request for a Multi-Partner Solution.
  This endpoint allows solution owners to decline incoming requests and maintain control
  over their solution partnerships and lifecycle.


  **Use Cases:**
  - Reject partnership requests from unauthorized or incompatible applications
  - Decline deactivation requests to keep solutions active
  - Maintain solution security and partnership quality
  - Control solution access and collaboration boundaries


  **Request Types:**
  - `PARTNERSHIP_REQUEST`: Reject an incoming partnership request from another app
  - `DEACTIVATION_REQUEST`: Reject a request to deactivate the solution


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Business Logic:**
  - Only solution owners can reject requests for their solutions
  - Partnership rejections require the partner_app_id parameter
  - Rejection actions are permanent and cannot be undone through this API
  - Rejected requests may need to be resubmitted through proper channels


  ## Examples

  ### Reject deactivation request

      %{
    "rejection_reason" => "Solution is still actively used by business customers",
    "request_type" => "DEACTIVATION_REQUEST"
  }

  ### Reject partnership request

      %{
    "partner_app_id" => "9876543210987654",
    "rejection_reason" => "Partnership terms do not align with our business requirements",
    "request_type" => "PARTNERSHIP_REQUEST"
  }
  """
  @spec reject_solution_request(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.SolutionReject.t()}
          | {:ok, WhatsApp.Resources.SolutionReject.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def reject_solution_request(client, solution_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{solution_id}/reject",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.SolutionReject)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.SolutionReject), resp}

      error ->
        error
    end
  end
end
