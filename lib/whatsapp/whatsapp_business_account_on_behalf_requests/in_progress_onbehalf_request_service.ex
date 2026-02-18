defmodule WhatsApp.WhatsappBusinessAccountOnBehalfRequests.InProgressOnbehalfRequestService do
  @moduledoc """
  APIs for managing WhatsApp Business Account on-behalf requests and business relationships
  """

  @doc """
  Get In-Progress On-Behalf Requests

  Retrieve a list of in-progress on-behalf requests for the specified WhatsApp Business Account.
  These requests represent pending business relationship requests that have been sent from
  this WhatsApp Business Account to other businesses and are awaiting approval.


  **Use Cases:**
  - Monitor pending on-behalf requests sent from your WhatsApp Business Account
  - Track business partnership request status and workflow
  - Retrieve details about requesting and receiving businesses for pending requests
  - Manage business relationship approval processes


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Pagination:**
  This endpoint supports cursor-based pagination. Use the 'after' and 'before' parameters
  to navigate through large result sets. The response includes pagination URLs for convenience.


  ## Parameters

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, status, business_owned_object).
  Available fields: id, status, business_owned_object, receiving_business, requesting_business

    - `limit` (integer, optional) - Maximum number of results to return per page. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for forward pagination. Use this to get the next page of results.

    - `before` (string, optional) - Cursor for backward pagination. Use this to get the previous page of results.

  """
  @spec get_in_progress_on_behalf_requests(WhatsApp.Client.t(), keyword()) ::
          {:ok, WhatsApp.Page.t()}
          | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_in_progress_on_behalf_requests(client, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    query_params =
      [
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{waba_id}/in_progress_onbehalf_request",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.BusinessOwnedObjectOnBehalfOfRequest
           )
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Page.from_response(
           data,
           &WhatsApp.Deserializer.deserialize(
             &1,
             WhatsApp.Resources.BusinessOwnedObjectOnBehalfOfRequest
           )
         ), resp}

      error ->
        error
    end
  end

  @doc "Stream version of `get_in_progress_on_behalf_requests/2` that auto-pages through all results."
  @spec stream_in_progress_on_behalf_requests(WhatsApp.Client.t(), keyword()) ::
          Enumerable.t() | {:error, WhatsApp.Error.t()}
  def stream_in_progress_on_behalf_requests(client, opts \\ []) do
    case get_in_progress_on_behalf_requests(client, opts) do
      {:ok, page} ->
        WhatsApp.Page.stream(page, client,
          deserialize_fn:
            &WhatsApp.Deserializer.deserialize(
              &1,
              WhatsApp.Resources.BusinessOwnedObjectOnBehalfOfRequest
            )
        )

      error ->
        error
    end
  end
end
