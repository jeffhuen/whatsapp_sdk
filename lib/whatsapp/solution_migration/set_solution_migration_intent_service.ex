defmodule WhatsApp.SolutionMigration.SetSolutionMigrationIntentService do
  @moduledoc """
  APIs for managing Multi-Partner Solution migration processes
  """

  @doc """
  Set Solution Migration Intent

  Set migration intent for a Multi-Partner Solution associated with a WhatsApp Business Account.
  This endpoint allows solution partners to initiate, schedule, confirm, or cancel migration
  processes for their solutions.


  **Use Cases:**
  - Initiate migration process for solution transitions
  - Schedule migration for a specific time
  - Confirm pending migration requests
  - Cancel previously set migration intents


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Migration Process:**
  1. Set migration intent with INITIATE_MIGRATION
  2. System validates migration eligibility
  3. Migration intent enters PENDING status
  4. Partner can schedule or confirm migration
  5. Migration executes at scheduled time or immediately upon confirmation


  ## Examples

  ### Cancel solution migration

      %{
    "migration_intent" => "CANCEL_MIGRATION",
    "migration_reason" => "Migration cancelled due to business requirements change",
    "solution_id" => "1234567890123456"
  }

  ### Initiate solution migration

      %{
    "migration_intent" => "INITIATE_MIGRATION",
    "migration_reason" => "Migrating to new solution provider for enhanced features",
    "solution_id" => "1234567890123456",
    "target_solution_id" => "2345678901234567"
  }

  ### Schedule solution migration

      %{
    "migration_intent" => "SCHEDULE_MIGRATION",
    "migration_reason" => "Scheduled migration during maintenance window",
    "scheduled_migration_time" => "2024-12-01T10:00:00Z",
    "solution_id" => "1234567890123456",
    "target_solution_id" => "2345678901234567"
  }
  """
  @spec set_solution_migration_intent(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.SetSolutionMigrationIntent.t()}
          | {:ok, WhatsApp.Resources.SetSolutionMigrationIntent.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def set_solution_migration_intent(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}/set_solution_migration_intent",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.SetSolutionMigrationIntent)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.SetSolutionMigrationIntent),
         resp}

      error ->
        error
    end
  end
end
