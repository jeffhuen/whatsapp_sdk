defmodule WhatsApp.WhatsappBusinessAccountUsers.AssignedUsersService do
  @moduledoc """
  APIs for managing user assignments and permissions for WhatsApp Business Accounts
  """

  @doc """
  Add User to WhatsApp Business Account

  Add a user to the WhatsApp Business Account with specified permission tasks.
  This operation grants the user access to perform specific actions on the account
  based on the provided permission tasks.


  **Use Cases:**
  - Grant user access to WhatsApp Business Account management
  - Assign specific permission tasks for granular access control
  - Add new team members to WhatsApp Business Account operations
  - Configure user permissions for different business roles


  **Permission Tasks:**
  Different permission tasks grant access to different WhatsApp Business Account features:
  - MANAGE: General account management permissions
  - DEVELOP: Development and API access permissions
  - MANAGE_TEMPLATES: Message template management
  - MANAGE_PHONE: Phone number management
  - MESSAGING: Send and receive messages
  - FULL_CONTROL: Complete access to all account features


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  ## Examples

  ### Add user with basic management permissions

      %{"tasks" => ["MANAGE", "VIEW_INSIGHTS"], "user" => "2345678901234567"}

  ### Add user with development permissions

      %{
    "tasks" => ["DEVELOP", "MANAGE_TEMPLATES", "VIEW_TEMPLATES"],
    "user" => "3456789012345678"
  }

  ### Add user with full control

      %{"tasks" => ["FULL_CONTROL"], "user" => "4567890123456789"}
  """
  @spec add_assigned_user(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.Success.t()}
          | {:ok, WhatsApp.Resources.Success.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def add_assigned_user(client, whatsapp_business_account_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{whatsapp_business_account_id}/assigned_users",
           [form: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Success)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Success), resp}

      error ->
        error
    end
  end

  @doc """
  List Assigned Users

  Retrieve a list of users assigned to the WhatsApp Business Account with their permissions
  and user details. This endpoint supports pagination and filtering capabilities.


  **Use Cases:**
  - Audit user access to WhatsApp Business Account
  - Retrieve user permission assignments for compliance
  - List all users with access for management purposes
  - Monitor user access patterns and assignments


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  **Caching:**
  User assignment data can be cached for short periods, but permission changes may occur
  frequently. Implement appropriate cache invalidation strategies.


  ## Parameters

    - `business` (string, **required**) - Business ID that owns or has access to the WhatsApp Business Account.
  This parameter is required to specify the business context for user assignments.

    - `fields` (string, optional) - Comma-separated list of fields to include in the response. If not specified,
  default fields will be returned (id, name). Available fields: id, name, business, user_type

    - `limit` (integer, optional) - Maximum number of assigned users to return per page. Default is 25, maximum is 100.

    - `after` (string, optional) - Cursor for pagination. Use this to get the next page of results.

    - `before` (string, optional) - Cursor for pagination. Use this to get the previous page of results.

  """
  @spec get_assigned_users(WhatsApp.Client.t(), String.t(), keyword()) ::
          {:ok, WhatsApp.Resources.AssignedUsers.t()}
          | {:ok, WhatsApp.Resources.AssignedUsers.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def get_assigned_users(client, whatsapp_business_account_id, opts \\ []) do
    query_params =
      [
        {:business, Keyword.get(opts, :business)},
        {:fields, Keyword.get(opts, :fields)},
        {:limit, Keyword.get(opts, :limit)},
        {:after, Keyword.get(opts, :after)},
        {:before, Keyword.get(opts, :before)}
      ]
      |> Enum.reject(fn {_, v} -> is_nil(v) end)

    case WhatsApp.Client.request(
           client,
           :get,
           "/#{client.api_version}/#{whatsapp_business_account_id}/assigned_users",
           [params: query_params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.AssignedUsers)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.AssignedUsers), resp}

      error ->
        error
    end
  end

  @doc """
  Remove User from WhatsApp Business Account

  Remove a user's access from the WhatsApp Business Account. This operation revokes
  all permissions and access rights for the specified user on the account.


  **Use Cases:**
  - Revoke user access when they leave the organization
  - Remove temporary access grants
  - Clean up user permissions for security compliance
  - Manage user lifecycle and access control


  **Important Notes:**
  - This operation removes ALL permissions for the user on this WhatsApp Business Account
  - The user will lose access to all account features and data
  - This action cannot be undone - the user must be re-added if access is needed again
  - Webhooks may be triggered to notify of user access changes


  **Rate Limiting:**
  Standard Graph API rate limits apply. Use appropriate retry logic with exponential backoff.


  ## Examples

  ### Remove user access

      %{"user" => "2345678901234567"}
  """
  @spec remove_assigned_user(WhatsApp.Client.t(), String.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.Success.t()}
          | {:ok, WhatsApp.Resources.Success.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def remove_assigned_user(client, whatsapp_business_account_id, params, opts \\ []) do
    case WhatsApp.Client.request(
           client,
           :delete,
           "/#{client.api_version}/#{whatsapp_business_account_id}/assigned_users",
           [form: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Success)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.Success), resp}

      error ->
        error
    end
  end
end
