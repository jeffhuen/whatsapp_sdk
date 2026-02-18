defmodule WhatsApp.MultiPartnerSolutions.RejectDeactivationRequestService do
  @moduledoc """
  APIs for managing Multi-Partner Solutions that enable collaborative WhatsApp Business
  messaging between solution owners and partner applications.

  """

  @doc """
  Reject Multi-Partner Solution Deactivation Request

  Reject a pending deactivation request for a Multi-Partner Solution. This endpoint allows
  solution partners to decline deactivation requests from solution owners, maintaining the
  solution in its current active operational state.


  **Use Cases:**
  - Reject deactivation requests from solution owners
  - Maintain active solution partnerships when deactivation is not appropriate
  - Respond programmatically to deactivation requests through API integration
  - Keep solutions operational when business requirements or partnerships change


  **Business Logic:**
  - Solution status remains ACTIVE after successful rejection
  - StatusForPendingRequest transitions from PENDING_DEACTIVATION to NONE
  - All existing solution configurations and permissions are preserved
  - Solution partners receive notifications about the rejection decision


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Permissions:**
  Requires whatsapp_business_management permission and valid solution partnership relationship.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (name, status, status_for_pending_request).
  Available fields: id, name, status, status_for_pending_request, owner_app, owner_permissions

  """
  @spec reject_solution_deactivation_request(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessSolution.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessSolution.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def reject_solution_deactivation_request(client, solution_id, params, opts \\ []) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{solution_id}/reject_deactivation_request",
           [json: params, params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessSolution)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessSolution),
         resp}

      error ->
        error
    end
  end
end
