defmodule WhatsApp.WhatsappBusinessSolutionManagement.AcceptDeactivationRequestService do
  @moduledoc """
  Operations for managing WhatsApp Business Multi-Partner Solutions including
  lifecycle management, status transitions, and partnership workflows.

  """

  @doc """
  Accept WhatsApp Business Solution Deactivation Request

  Accepts a pending deactivation request for a WhatsApp Business Multi-Partner Solution.


  This endpoint completes the partner approval workflow by accepting a deactivation request
  that was previously initiated by another solution partner. Upon successful acceptance,
  the solution status transitions from ACTIVE to DEACTIVATED, and the pending request
  status changes from PENDING_DEACTIVATION to NONE.


  **Important Business Logic:**

  - Solution must be in ACTIVE status with PENDING_DEACTIVATION pending status

  - All outstanding payments and invoices must be settled before acceptance

  - Active marketing campaigns must be concluded or transferred

  - Webhook notifications will be sent to all solution partners upon completion

  - Solution resources and permissions will be cleaned up according to policy


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to return in the response.


  **Available Fields:** id, name, status, status_for_pending_request, owner_permissions


  **Default Fields:** name, status, status_for_pending_request

  """
  @spec accept_whats_app_business_solution_deactivation_request(
          WhatsApp.Client.t(),
          String.t(),
          map(),
          keyword()
        ) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessSolution.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessSolution.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def accept_whats_app_business_solution_deactivation_request(
        client,
        solution_id,
        params,
        opts \\ []
      ) do
    query_params =
      [{:fields, Keyword.get(opts, :fields)}] |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{solution_id}/accept_deactivation_request",
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
