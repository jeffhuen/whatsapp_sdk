defmodule WhatsApp.OboMobilityIntent.OboMobilityIntentService do
  @moduledoc """
  APIs for managing On-Behalf-Of mobility intent operations for WhatsApp Business Accounts
  """

  @doc """
  Create OBO Mobility Intent

  Create a new On-Behalf-Of mobility intent for a WhatsApp Business Account.
  This endpoint allows authorized solution providers to initiate mobility operations
  on behalf of business accounts, facilitating transfers and handovers between
  different solution providers.


  **Use Cases:**
  - Initiate account mobility process between solution providers
  - Request handover of account management
  - Schedule mobility operations for future execution
  - Coordinate multi-partner solution transitions


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Mobility Process:**
  1. Create mobility intent with appropriate intent type
  2. System validates mobility eligibility and permissions
  3. Intent enters PENDING status awaiting approvals
  4. Partner notifications and approval workflows are triggered
  5. Upon approval, mobility operation is scheduled or executed
  6. Status updates are provided throughout the process


  ## Examples

  ### Cancel mobility operation

      %{
    "intent_type" => "CANCEL_TRANSFER",
    "mobility_reason" => "Transfer cancelled due to business requirements change",
    "solution_id" => "2345678901234567"
  }

  ### Initiate account transfer

      %{
    "intent_type" => "INITIATE_TRANSFER",
    "metadata" => %{
      "business_justification" => "Business restructuring",
      "partner_approval_id" => "approval_123456"
    },
    "mobility_reason" => "Transferring account management to new solution provider",
    "solution_id" => "2345678901234567",
    "target_solution_id" => "3456789012345678"
  }

  ### Request account handover

      %{
    "intent_type" => "REQUEST_HANDOVER",
    "mobility_reason" => "Scheduled handover during maintenance window",
    "scheduled_execution_time" => "2024-12-01T10:00:00Z",
    "solution_id" => "2345678901234567",
    "target_solution_id" => "3456789012345678"
  }
  """
  @spec create_obo_mobility_intent(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.OBOMobilityIntent.t()}
          | {:ok, WhatsApp.Resources.OBOMobilityIntent.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def create_obo_mobility_intent(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}/obo_mobility_intent",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.OBOMobilityIntent)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.OBOMobilityIntent), resp}

      error ->
        error
    end
  end
end
