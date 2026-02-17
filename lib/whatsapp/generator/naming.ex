defmodule WhatsApp.Generator.Naming do
  @moduledoc false

  # Domain key -> module name segment

  @domain_modules %{
    "messages" => "Messages",
    "media" => "Media",
    "templates" => "Templates",
    "phone_numbers" => "PhoneNumbers",
    "business_profiles" => "BusinessProfiles",
    "flows" => "Flows",
    "qr_codes" => "QrCodes",
    "calls" => "Calls",
    "business_management" => "BusinessManagement",
    "groups" => "Groups",
    "webhooks" => "Webhooks"
  }

  @doc false
  @spec domain_module_name(String.t()) :: String.t()
  def domain_module_name(domain) do
    Map.get_lazy(@domain_modules, domain, fn -> camelize(domain) end)
  end

  # Schema name -> resource module name (strip common suffixes)

  @doc false
  @spec resource_module_name(String.t()) :: String.t()
  def resource_module_name(schema_name) do
    schema_name
    |> String.replace(~r/Details$/, "")
    |> String.replace(~r/Response$/, "")
  end

  # Build service file path

  @doc false
  @spec service_path(String.t(), String.t()) :: String.t()
  def service_path(domain, resource) do
    "lib/whatsapp/#{Macro.underscore(domain)}/#{Macro.underscore(resource)}_service.ex"
  end

  # Build resource file path

  @doc false
  @spec resource_path(String.t()) :: String.t()
  def resource_path(resource) do
    "lib/whatsapp/resources/#{Macro.underscore(resource)}.ex"
  end

  # operationId -> function name
  # "sendMessage" -> :send_message
  # "getPhoneNumberById" -> :get_phone_number_by_id

  @doc false
  @spec function_name(String.t()) :: atom()
  def function_name(operation_id) do
    operation_id
    |> Macro.underscore()
    |> String.to_atom()
  end

  # Inline schema naming
  # For request body: "{OperationId}Request"
  # For 200 response: "{OperationId}Response"
  # For non-200: "{OperationId}{StatusCode}Response"
  # For nested: "{ParentSchema}{PropertyName}"

  @doc false
  @spec inline_request_schema_name(String.t()) :: String.t()
  def inline_request_schema_name(operation_id), do: "#{operation_id}Request"

  @doc false
  @spec inline_response_schema_name(String.t(), pos_integer()) :: String.t()
  def inline_response_schema_name(operation_id, 200), do: "#{operation_id}Response"
  def inline_response_schema_name(operation_id, status), do: "#{operation_id}#{status}Response"

  @doc false
  @spec inline_nested_schema_name(String.t(), String.t()) :: String.t()
  def inline_nested_schema_name(parent, property), do: "#{parent}#{camelize(property)}"

  # Collision handling: append numeric suffix

  @doc false
  @spec resolve_collision(String.t(), MapSet.t(String.t())) :: String.t()
  def resolve_collision(name, existing_names) do
    if name in existing_names do
      find_available(name, existing_names, 1)
    else
      name
    end
  end

  # Full module name for a service
  # e.g., service_module_name("Messages", "Message") -> "WhatsApp.Messages.MessageService"

  @doc false
  @spec service_module_name(String.t(), String.t()) :: String.t()
  def service_module_name(domain, resource) do
    "WhatsApp.#{domain}.#{resource}Service"
  end

  # Full module name for a resource
  # e.g., resource_module_name_full("QrCode") -> "WhatsApp.Resources.QrCode"

  @doc false
  @spec resource_module_name_full(String.t()) :: String.t()
  def resource_module_name_full(resource) do
    "WhatsApp.Resources.#{resource}"
  end

  # Determine where a path parameter comes from

  @client_config_params MapSet.new(["phone_number_id", "business_account_id", "waba_id"])

  @doc false
  @spec id_source(String.t()) :: :client_config | :function_arg
  def id_source(param) do
    if param in @client_config_params do
      :client_config
    else
      :function_arg
    end
  end

  # Private helpers

  defp find_available(base, existing, n) do
    candidate = "#{base}_#{n}"

    if candidate in existing do
      find_available(base, existing, n + 1)
    else
      candidate
    end
  end

  defp camelize(string) do
    string
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join()
  end
end
