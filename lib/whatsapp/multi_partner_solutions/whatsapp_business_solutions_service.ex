defmodule WhatsApp.MultiPartnerSolutions.WhatsappBusinessSolutionsService do
  @moduledoc """
  APIs for managing Multi-Partner Solutions that enable collaborative WhatsApp Business
  messaging between solution owners and partner applications.

  """

  @doc """
  Get Multi-Partner Solutions for Application

  Retrieve all WhatsApp Business Multi-Partner Solutions associated with the specified application.
  This includes both solutions owned by the application and solutions where the application
  acts as a partner.


  **Use Cases:**
  - Retrieve all solutions for an application's portfolio management
  - Filter solutions by ownership role (owner vs partner)
  - Monitor solution lifecycle and status changes across multiple solutions
  - Verify solution configuration before business onboarding operations
  - Check pending approval requests and status transitions


  **Filtering:**
  Use the `role` parameter to filter solutions by the application's relationship:
  - `OWNER`: Only solutions owned by this application
  - `PARTNER`: Only solutions where this application is a partner
  - No role parameter: All solutions (both owned and partnered)


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  Solution details can be cached for short periods, but status information may change
  frequently during transitions. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `role` (, optional) - Filter solutions by the application's relationship role. If not specified,
  all solutions (both owned and partnered) will be returned.

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (name, status, status_for_pending_request).
  Available fields: id, name, status, status_for_pending_request, owner_app, owner_permissions

    - `limit` (integer, optional) - Maximum number of solutions to return in a single request. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use this to get the next page of results.

    - `before` (string, optional) - Cursor for pagination. Use this to get the previous page of results.

  """
  @spec get_application_whats_app_business_solutions(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.WhatsAppBusinessSolutions.t()}
          | {:ok, WhatsApp.Resources.WhatsAppBusinessSolutions.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_application_whats_app_business_solutions(client, application_id, opts \\ []) do
    query_params =
      [
        {:role, Keyword.get(opts, :role)},
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{application_id}/whatsapp_business_solutions",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessSolutions)}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.WhatsAppBusinessSolutions),
         resp}

      error ->
        error
    end
  end
end
