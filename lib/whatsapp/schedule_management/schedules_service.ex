defmodule WhatsApp.ScheduleManagement.SchedulesService do
  @moduledoc """
  APIs for managing WhatsApp Business Account schedules and scheduling configurations
  """

  @doc """
  Create WhatsApp Business Account Schedule

  Create a new schedule configuration within a WhatsApp Business Account. This endpoint
  allows businesses to set up automated scheduling for various operations such as business hours,
  automated responses, and maintenance windows.

  **Use Cases:**
  - Create business hours schedules for automated responses
  - Set up maintenance windows for system operations
  - Configure automated message campaigns with timing
  - Establish recurring schedule patterns for business operations

  **Prerequisites:**
  - WhatsApp Business Account must have scheduling feature enabled
  - Appropriate permissions for schedule management
  - Valid timezone and time format specifications
  - Business must meet WhatsApp Business API requirements

  **Process Flow:**
  1. Submit schedule configuration with timing and recurrence details
  2. System validates schedule parameters and conflicts
  3. Schedule is created and activated based on is_active flag
  4. Monitor schedule status through GET endpoint

  **Rate Limiting:**
  Schedule creation is subject to rate limits to prevent abuse.
  Standard Graph API rate limits also apply.

  **Validation:**
  - Start time must be before end time
  - Timezone must be valid IANA timezone identifier
  - Days of week must be valid if specified
  - Recurrence pattern must be consistent with schedule type


  ## Examples

  ### Automated response schedule

      %{
    "days_of_week" => ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY",
     "SATURDAY", "SUNDAY"],
    "description" => "Automated responses outside business hours",
    "end_time" => "08:00",
    "is_active" => true,
    "name" => "After Hours Auto-Reply",
    "schedule_type" => "AUTOMATED_RESPONSE",
    "start_time" => "18:00",
    "timezone" => "America/Los_Angeles"
  }

  ### Business hours schedule creation

      %{
    "days_of_week" => ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"],
    "description" => "Standard business operating hours",
    "end_time" => "17:00",
    "is_active" => true,
    "name" => "Business Hours Schedule",
    "recurrence_pattern" => %{"frequency" => "WEEKLY", "interval" => 1},
    "schedule_type" => "BUSINESS_HOURS",
    "start_time" => "09:00",
    "timezone" => "America/New_York"
  }

  ### Maintenance window schedule

      %{
    "days_of_week" => ["SATURDAY", "SUNDAY"],
    "description" => "System maintenance during off-hours",
    "end_time" => "04:00",
    "is_active" => false,
    "name" => "Weekend Maintenance",
    "schedule_type" => "MAINTENANCE_WINDOW",
    "start_time" => "02:00",
    "timezone" => "UTC"
  }
  """
  @spec create_whats_app_business_account_schedule(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.ScheduleCreate.t()}
          | {:ok, WhatsApp.Resources.ScheduleCreate.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def create_whats_app_business_account_schedule(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}/schedules",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ScheduleCreate)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.ScheduleCreate), resp}

      error ->
        error
    end
  end

  @doc """
  Get WhatsApp Business Account Schedules

  Retrieve all schedules associated with a WhatsApp Business Account, including their
  configuration, status, and execution details.

  **Use Cases:**
  - List all schedules in a WhatsApp Business Account
  - Monitor schedule status and performance
  - Check schedule configuration and timing details
  - Retrieve schedule execution history and metrics

  **Filtering:**
  You can filter results using the `filtering` parameter with JSON-encoded filter conditions.
  Supported filters include status, schedule_type, and is_active.

  **Sorting:**
  Results can be sorted by created_time or updated_time in ascending or descending order.

  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.

  **Caching:**
  Schedule data can be cached for short periods, but status information may change
  frequently. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned. Available fields include: id, name, status,
  schedule_type, description, start_time, end_time, timezone, days_of_week,
  created_time, updated_time, is_active, recurrence_pattern

    - `filtering` (string, optional) - JSON-encoded array of filter conditions. Each filter should specify field, operator, and value.
  Supported fields: status, schedule_type, is_active

    - `sort` (string, optional) - Sort field and direction. Format: field_name.asc or field_name.desc
  Supported fields: created_time, updated_time

    - `limit` (integer, optional) - Maximum number of schedules to return per page
    - `after` (string, optional) - Cursor for pagination - retrieve records after this cursor
    - `before` (string, optional) - Cursor for pagination - retrieve records before this cursor
  """
  @spec get_whats_app_business_account_schedules(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_whats_app_business_account_schedules(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:filtering, Keyword.get(opts, :filtering)},
        {:sort, Keyword.get(opts, :sort)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{waba_id}/schedules",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.WhatsAppBusinessAccountSchedule
           )
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.WhatsAppBusinessAccountSchedule
           )
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `get_whats_app_business_account_schedules/2` that auto-pages through all results."
  @spec stream_whats_app_business_account_schedules(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_whats_app_business_account_schedules(client, opts \\ []) do
    case get_whats_app_business_account_schedules(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn:
            &WhatsApp.Deserializer.deserialize(
              &1,
              WhatsApp.Resources.WhatsAppBusinessAccountSchedule
            )
        )

      error ->
        error
    end
  end
end
