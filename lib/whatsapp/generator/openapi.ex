defmodule WhatsApp.Generator.OpenAPI do
  @moduledoc false

  alias WhatsApp.Generator.Naming

  # ── Public API ──────────────────────────────────────────────────────────

  @doc """
  Parse an OpenAPI 3.1.0 JSON spec file into a normalized structure.

  Returns a map with keys: `:info`, `:server_url`, `:api_version`, `:auth`,
  `:tags`, `:parameter_groups`, `:schemas`, `:response_headers`, `:domains`.
  """
  @spec parse(String.t()) :: map()
  def parse(path) do
    raw = path |> File.read!() |> JSON.decode!()

    schemas = parse_schemas(raw)
    inline_schemas = collect_inline_schemas(raw, schemas)
    all_schemas = Map.merge(schemas, inline_schemas)

    %{
      info: parse_info(raw),
      server_url: parse_server_url(raw),
      api_version: parse_api_version(raw),
      auth: parse_auth(raw),
      tags: parse_tags(raw),
      parameter_groups: parse_parameter_groups(raw),
      schemas: all_schemas,
      response_headers: parse_response_headers(raw),
      domains: parse_domains(raw)
    }
  end

  # ── Step 2: Top-level metadata ──────────────────────────────────────────

  @doc false
  @spec parse_info(map()) :: map()
  def parse_info(raw) do
    info = Map.get(raw, "info", %{})

    %{
      title: Map.get(info, "title"),
      description: Map.get(info, "description"),
      version: Map.get(info, "version"),
      contact: parse_contact(Map.get(info, "contact")),
      license: parse_license(Map.get(info, "license")),
      terms_of_service: Map.get(info, "termsOfService")
    }
  end

  defp parse_contact(nil), do: nil

  defp parse_contact(contact) do
    %{
      name: Map.get(contact, "name"),
      url: Map.get(contact, "url")
    }
  end

  defp parse_license(nil), do: nil

  defp parse_license(license) do
    %{
      name: Map.get(license, "name"),
      url: Map.get(license, "url")
    }
  end

  @doc false
  @spec parse_server_url(map()) :: String.t() | nil
  def parse_server_url(raw) do
    case Map.get(raw, "servers", []) do
      [%{"url" => url} | _] -> url
      _ -> nil
    end
  end

  @doc false
  @spec parse_api_version(map()) :: String.t() | nil
  def parse_api_version(raw) do
    get_in(raw, ["info", "version"])
  end

  @doc false
  @spec parse_auth(map()) :: atom() | nil
  def parse_auth(raw) do
    security_schemes = get_in(raw, ["components", "securitySchemes"]) || %{}

    if Map.has_key?(security_schemes, "bearerAuth"), do: :bearer
  end

  # ── Step 3: Tags ────────────────────────────────────────────────────────

  @doc false
  @spec parse_tags(map()) :: map()
  def parse_tags(raw) do
    raw
    |> Map.get("tags", [])
    |> Map.new(fn tag ->
      {Map.get(tag, "name"), %{description: Map.get(tag, "description", "")}}
    end)
  end

  # ── Step 4: Parameter groups ────────────────────────────────────────────

  @doc false
  @spec parse_parameter_groups(map()) :: map()
  def parse_parameter_groups(raw) do
    get_in(raw, ["components", "parameterGroups"]) || %{}
  end

  # ── Step 5 & 10–11: Schemas ────────────────────────────────────────────

  @doc false
  @spec parse_schemas(map()) :: map()
  def parse_schemas(raw) do
    raw
    |> get_in(["components", "schemas"])
    |> Kernel.||(%{})
    |> Map.new(fn {name, schema} -> {name, parse_single_schema(schema, raw)} end)
  end

  @doc false
  @spec parse_single_schema(map(), map()) :: map()
  def parse_single_schema(schema, raw) do
    base = %{
      type: parse_type(schema),
      description: Map.get(schema, "description")
    }

    base
    |> maybe_put(:required, parse_required(schema))
    |> maybe_put(:enum, Map.get(schema, "enum"))
    |> maybe_put(:const, Map.get(schema, "const"))
    |> maybe_put(:default, Map.get(schema, "default"))
    |> maybe_put(:example, Map.get(schema, "example"))
    |> maybe_put(:format, parse_format(Map.get(schema, "format")))
    |> maybe_put(:pattern, Map.get(schema, "pattern"))
    |> maybe_put(:nullable, parse_nullable(schema))
    |> maybe_put(:additional_properties, parse_additional_properties(schema))
    |> maybe_put(:min_length, Map.get(schema, "minLength"))
    |> maybe_put(:max_length, Map.get(schema, "maxLength"))
    |> maybe_put(:minimum, Map.get(schema, "minimum"))
    |> maybe_put(:maximum, Map.get(schema, "maximum"))
    |> maybe_put(:min_items, Map.get(schema, "minItems"))
    |> maybe_put(:max_items, Map.get(schema, "maxItems"))
    |> maybe_put(:one_of, parse_one_of(schema, raw))
    |> maybe_put(:all_of, parse_all_of(schema, raw))
    |> maybe_put(:not, parse_not(schema))
    |> maybe_put(:discriminator, parse_discriminator(schema))
    |> maybe_put(:properties, parse_properties(schema, raw))
    |> maybe_put(:items, parse_items(schema, raw))
  end

  defp parse_type(%{"type" => "object"}), do: :object
  defp parse_type(%{"type" => "string"}), do: :string
  defp parse_type(%{"type" => "integer"}), do: :integer
  defp parse_type(%{"type" => "number"}), do: :number
  defp parse_type(%{"type" => "boolean"}), do: :boolean
  defp parse_type(%{"type" => "array"}), do: :array
  defp parse_type(%{"allOf" => _}), do: :object
  defp parse_type(%{"oneOf" => _}), do: :union
  defp parse_type(_), do: nil

  defp parse_required(%{"required" => required}) when is_list(required), do: required
  defp parse_required(_), do: nil

  defp parse_format(nil), do: nil
  defp parse_format("date-time"), do: :date_time
  defp parse_format("date"), do: :date
  defp parse_format("time"), do: :time
  defp parse_format("email"), do: :email
  defp parse_format("uri"), do: :uri
  defp parse_format("int32"), do: :int32
  defp parse_format("int64"), do: :int64
  defp parse_format("binary"), do: :binary
  defp parse_format(other), do: String.to_atom(other)

  defp parse_nullable(%{"nullable" => true}), do: true
  defp parse_nullable(_), do: nil

  defp parse_additional_properties(%{"additionalProperties" => val}) when is_boolean(val),
    do: val

  defp parse_additional_properties(_), do: nil

  defp parse_one_of(%{"oneOf" => items}, raw) do
    Enum.map(items, fn
      %{"$ref" => ref} -> ref_name(ref)
      inline -> parse_single_schema(inline, raw)
    end)
  end

  defp parse_one_of(_, _), do: nil

  defp parse_all_of(%{"allOf" => items}, raw) do
    Enum.map(items, fn
      %{"$ref" => ref} -> ref_name(ref)
      inline -> parse_single_schema(inline, raw)
    end)
  end

  defp parse_all_of(_, _), do: nil

  defp parse_not(%{"not" => not_schema}), do: not_schema
  defp parse_not(_), do: nil

  defp parse_discriminator(%{"discriminator" => disc}) do
    mapping =
      disc
      |> Map.get("mapping", %{})
      |> Map.new(fn {key, ref} -> {key, ref_name(ref)} end)

    %{
      property_name: Map.get(disc, "propertyName"),
      mapping: mapping
    }
  end

  defp parse_discriminator(_), do: nil

  defp parse_properties(%{"properties" => props}, raw) when map_size(props) > 0 do
    Enum.map(props, fn {name, prop} ->
      parse_property(name, prop, raw)
    end)
  end

  defp parse_properties(_, _), do: nil

  defp parse_property(name, prop, raw) do
    resolved = resolve_ref(raw, prop)

    base = %{
      name: name,
      type: parse_property_type(resolved, raw)
    }

    base
    |> maybe_put(:description, Map.get(resolved, "description"))
    |> maybe_put(:format, parse_format(Map.get(resolved, "format")))
    |> maybe_put(:enum, Map.get(resolved, "enum"))
    |> maybe_put(:const, Map.get(resolved, "const"))
    |> maybe_put(:default, Map.get(resolved, "default"))
    |> maybe_put(:example, Map.get(resolved, "example"))
    |> maybe_put(:pattern, Map.get(resolved, "pattern"))
    |> maybe_put(:nullable, parse_nullable(resolved))
    |> maybe_put(:min_length, Map.get(resolved, "minLength"))
    |> maybe_put(:max_length, Map.get(resolved, "maxLength"))
    |> maybe_put(:minimum, Map.get(resolved, "minimum"))
    |> maybe_put(:maximum, Map.get(resolved, "maximum"))
    |> maybe_put(:min_items, Map.get(resolved, "minItems"))
    |> maybe_put(:max_items, Map.get(resolved, "maxItems"))
    |> maybe_put(:items, parse_items(resolved, raw))
    |> maybe_put(:additional_properties, parse_additional_properties(resolved))
  end

  defp parse_property_type(%{"type" => "array", "items" => items}, raw) do
    item_type = parse_item_type(items, raw)
    {:array, item_type}
  end

  defp parse_property_type(%{"type" => type}, _raw), do: String.to_atom(type)
  defp parse_property_type(%{"$ref" => ref}, _raw), do: {:ref, ref_name(ref)}
  defp parse_property_type(%{"oneOf" => _}, _raw), do: :union
  defp parse_property_type(%{"allOf" => _}, _raw), do: :object
  defp parse_property_type(_, _), do: nil

  defp parse_item_type(%{"type" => type}, _raw), do: String.to_atom(type)
  defp parse_item_type(%{"$ref" => ref}, _raw), do: {:ref, ref_name(ref)}
  defp parse_item_type(_, _), do: :any

  defp parse_items(%{"type" => "array", "items" => items}, raw) do
    case items do
      %{"$ref" => ref} ->
        %{type: {:ref, ref_name(ref)}}

      %{"type" => type} = item_schema ->
        parsed = %{type: String.to_atom(type)}

        parsed
        |> maybe_put(:format, parse_format(Map.get(item_schema, "format")))
        |> maybe_put(:properties, parse_properties(item_schema, raw))

      _ ->
        %{type: :any}
    end
  end

  defp parse_items(_, _), do: nil

  # ── Step 12: Inline schema naming ──────────────────────────────────────

  @spec collect_inline_schemas(map(), map()) :: map()
  defp collect_inline_schemas(raw, existing_schemas) do
    existing_names = MapSet.new(Map.keys(existing_schemas))

    raw
    |> Map.get("paths", %{})
    |> Enum.flat_map(fn {_path, path_item} ->
      path_item
      |> operation_entries()
      |> Enum.flat_map(fn {_method, operation} ->
        op_id = Map.get(operation, "operationId", "unknown")
        collect_operation_inline_schemas(operation, op_id, raw, existing_names)
      end)
    end)
    |> Map.new()
  end

  defp collect_operation_inline_schemas(operation, op_id, raw, existing_names) do
    request_schemas = collect_request_inline_schemas(operation, op_id, raw, existing_names)
    response_schemas = collect_response_inline_schemas(operation, op_id, raw, existing_names)
    request_schemas ++ response_schemas
  end

  defp collect_request_inline_schemas(operation, op_id, raw, existing_names) do
    case get_request_body_schema(operation) do
      {_content_type, %{"$ref" => _}} ->
        []

      {_content_type, inline_schema} when map_size(inline_schema) > 0 ->
        name = Naming.resolve_collision(Naming.inline_request_schema_name(op_id), existing_names)
        [{name, parse_single_schema(inline_schema, raw)}]

      _ ->
        []
    end
  end

  defp collect_response_inline_schemas(operation, op_id, raw, existing_names) do
    operation
    |> Map.get("responses", %{})
    |> Enum.flat_map(fn {status_code, response} ->
      resolved_response = resolve_ref(raw, response)

      case get_response_schema(resolved_response) do
        %{"$ref" => _} ->
          []

        inline_schema when is_map(inline_schema) and map_size(inline_schema) > 0 ->
          status = parse_status_code(status_code)

          name =
            Naming.resolve_collision(
              Naming.inline_response_schema_name(op_id, status),
              existing_names
            )

          [{name, parse_single_schema(inline_schema, raw)}]

        _ ->
          []
      end
    end)
  end

  # ── Step 6 & 14: Domains ────────────────────────────────────────────────

  @doc false
  @spec parse_domains(map()) :: [map()]
  def parse_domains(raw) do
    tags = parse_tags(raw)

    operations_by_tag = group_operations_by_tag(raw)

    operations_by_tag
    |> Enum.map(fn {tag, operations} ->
      domain_name = tag_to_domain_name(tag)
      module_name = Naming.domain_module_name(domain_name)
      tag_info = Map.get(tags, tag, %{description: ""})

      resources = group_operations_into_resources(operations, raw)

      %{
        name: domain_name,
        module_name: module_name,
        tag_description: Map.get(tag_info, :description, ""),
        resources: resources
      }
    end)
    |> Enum.sort_by(& &1.name)
  end

  defp group_operations_by_tag(raw) do
    raw
    |> Map.get("paths", %{})
    |> Enum.flat_map(fn {path, path_item} ->
      path_params = path_level_parameters(path_item, raw)

      path_item
      |> operation_entries()
      |> Enum.map(fn {method, operation} ->
        {path, method, operation, path_params}
      end)
    end)
    |> Enum.group_by(fn {path, _method, operation, _path_params} ->
      case Map.get(operation, "tags", []) do
        [primary_tag | _] -> primary_tag
        [] -> infer_tag_from_path(path)
      end
    end)
  end

  defp infer_tag_from_path(path) do
    # Heuristic for untagged operations: derive from path segments
    path
    |> String.split("/")
    |> Enum.reject(&(String.starts_with?(&1, "{") or &1 == ""))
    |> List.last()
    |> Kernel.||("unknown")
    |> then(fn segment ->
      segment
      |> String.replace("_", " ")
      |> String.split()
      |> Enum.map_join(" ", &String.capitalize/1)
    end)
  end

  defp tag_to_domain_name(tag) do
    tag
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]+/, "_")
    |> String.trim("_")
  end

  defp group_operations_into_resources(operations, raw) do
    operations
    |> Enum.map(fn {path, method, operation, path_params} ->
      parse_operation(path, method, operation, path_params, raw)
    end)
    |> Enum.group_by(&resource_key/1)
    |> Enum.map(fn {resource_key, ops} ->
      module_name = resource_module_from_key(resource_key)

      %{
        name: resource_key,
        module_name: module_name,
        operations: Enum.sort_by(ops, & &1.name)
      }
    end)
    |> Enum.sort_by(& &1.name)
  end

  defp resource_key(operation) do
    # Derive resource name from path: last non-parameter segment
    operation.path
    |> String.split("/")
    |> Enum.reject(&(String.starts_with?(&1, "{") or &1 == ""))
    |> List.last()
    |> Kernel.||("root")
    |> Macro.underscore()
  end

  defp resource_module_from_key(key) do
    key
    |> String.split("_")
    |> Enum.map_join(&String.capitalize/1)
  end

  # ── Step 7: Operation parsing ──────────────────────────────────────────

  defp parse_operation(path, method, operation, path_params, raw) do
    op_id = Map.get(operation, "operationId", "")
    all_params = merge_parameters(path_params, Map.get(operation, "parameters", []), raw)
    extracted_path_params = extract_path_params(path)

    # Determine the primary path param (first non-version path param)
    id_param =
      extracted_path_params
      |> Enum.reject(&(&1 == :version))
      |> List.first()

    {content_type, request_schema} = extract_request_info(operation, op_id, raw)
    response_schemas = extract_response_schemas(operation, op_id, raw)
    request_examples = extract_request_examples(operation)
    response_examples = extract_response_examples(operation, raw)

    %{
      name: derive_operation_name(op_id, method),
      operation_id: op_id,
      method: String.to_atom(method),
      path: path,
      path_params: extracted_path_params,
      id_source: id_param,
      summary: Map.get(operation, "summary"),
      description: Map.get(operation, "description"),
      tags: Map.get(operation, "tags", []),
      security: parse_security(operation),
      content_type: content_type,
      request_body_required: get_in(operation, ["requestBody", "required"]) || false,
      request_schema: request_schema,
      response_schemas: response_schemas,
      request_examples: request_examples,
      response_examples: response_examples,
      parameters: Enum.map(all_params, &normalize_parameter(&1, raw))
    }
  end

  defp derive_operation_name(op_id, _method) when op_id != "" do
    Naming.function_name(op_id)
  end

  defp derive_operation_name(_op_id, method) do
    String.to_atom(method)
  end

  defp extract_path_params(path) do
    ~r/\{([^}]+)\}/
    |> Regex.scan(path)
    |> Enum.map(fn [_, param] ->
      param
      |> String.replace("-", "_")
      |> String.downcase()
      |> String.to_atom()
    end)
  end

  defp parse_security(operation) do
    operation
    |> Map.get("security", [])
    |> Enum.flat_map(fn security_map ->
      Map.keys(security_map)
    end)
    |> Enum.map(fn
      "bearerAuth" -> :bearer_auth
      other -> String.to_atom(other)
    end)
  end

  defp extract_request_info(operation, op_id, raw) do
    case get_request_body_content(operation) do
      nil ->
        {nil, nil}

      {content_type, content} ->
        schema = Map.get(content, "schema", %{})

        schema_name =
          case schema do
            %{"$ref" => ref} -> ref_name(ref)
            _ when map_size(schema) > 0 -> Naming.inline_request_schema_name(op_id)
            _ -> nil
          end

        {content_type, resolve_schema_name(schema_name, raw)}
    end
  end

  defp get_request_body_content(operation) do
    case get_in(operation, ["requestBody", "content"]) do
      nil ->
        nil

      content when is_map(content) ->
        # Pick the first content type
        case Map.to_list(content) do
          [{content_type, body} | _] -> {content_type, body}
          _ -> nil
        end
    end
  end

  defp get_request_body_schema(operation) do
    case get_request_body_content(operation) do
      {content_type, body} -> {content_type, Map.get(body, "schema", %{})}
      nil -> {nil, %{}}
    end
  end

  defp extract_response_schemas(operation, op_id, raw) do
    operation
    |> Map.get("responses", %{})
    |> Map.new(fn {status_code, response} ->
      resolved = resolve_ref(raw, response)
      status = parse_status_code(status_code)

      schema_name =
        case get_response_schema(resolved) do
          %{"$ref" => ref} ->
            ref_name(ref)

          inline when is_map(inline) and map_size(inline) > 0 ->
            Naming.inline_response_schema_name(op_id, status)

          _ ->
            nil
        end

      {status, resolve_schema_name(schema_name, raw)}
    end)
  end

  defp get_response_schema(response) do
    case get_in(response, ["content", "application/json", "schema"]) do
      nil -> nil
      schema -> schema
    end
  end

  defp resolve_schema_name(nil, _raw), do: nil
  defp resolve_schema_name(name, _raw), do: name

  # ── Step 8: Examples ───────────────────────────────────────────────────

  defp extract_request_examples(operation) do
    case get_request_body_content(operation) do
      {_content_type, body} ->
        body
        |> Map.get("examples", %{})
        |> Enum.map(fn {name, example} ->
          %{
            name: name,
            summary: Map.get(example, "summary"),
            value: Map.get(example, "value")
          }
        end)

      nil ->
        []
    end
  end

  defp extract_response_examples(operation, raw) do
    operation
    |> Map.get("responses", %{})
    |> Map.new(fn {status_code, response} ->
      resolved = resolve_ref(raw, response)
      status = parse_status_code(status_code)
      examples = extract_json_examples(resolved)
      {status, examples}
    end)
    |> Enum.reject(fn {_status, examples} -> examples == [] end)
    |> Map.new()
  end

  defp extract_json_examples(resolved_response) do
    case get_in(resolved_response, ["content", "application/json", "examples"]) do
      nil ->
        []

      examples_map ->
        Enum.map(examples_map, fn {name, example} ->
          %{
            name: name,
            summary: Map.get(example, "summary"),
            value: Map.get(example, "value")
          }
        end)
    end
  end

  # ── Step 9: Parameters ─────────────────────────────────────────────────

  defp path_level_parameters(path_item, raw) do
    path_item
    |> Map.get("parameters", [])
    |> Enum.map(&resolve_ref(raw, &1))
  end

  defp merge_parameters(path_params, op_params, raw) do
    resolved_op = Enum.map(op_params, &resolve_ref(raw, &1))
    op_names = MapSet.new(resolved_op, &Map.get(&1, "name"))

    # Operation params override path-level params of the same name
    deduped_path = Enum.reject(path_params, &(Map.get(&1, "name") in op_names))
    deduped_path ++ resolved_op
  end

  defp normalize_parameter(param, _raw) do
    schema = Map.get(param, "schema", %{})

    base = %{
      name: Map.get(param, "name"),
      in: parse_param_in(Map.get(param, "in")),
      required: Map.get(param, "required", false)
    }

    base
    |> maybe_put(:description, Map.get(param, "description"))
    |> maybe_put(:type, parse_param_type(schema))
    |> maybe_put(:enum, Map.get(schema, "enum"))
    |> maybe_put(:default, Map.get(schema, "default"))
    |> maybe_put(:example, Map.get(param, "example") || Map.get(schema, "example"))
    |> maybe_put(:min_length, Map.get(schema, "minLength"))
    |> maybe_put(:max_length, Map.get(schema, "maxLength"))
    |> maybe_put(:minimum, Map.get(schema, "minimum"))
    |> maybe_put(:maximum, Map.get(schema, "maximum"))
    |> maybe_put(:pattern, Map.get(schema, "pattern"))
  end

  defp parse_param_in("path"), do: :path
  defp parse_param_in("query"), do: :query
  defp parse_param_in("header"), do: :header
  defp parse_param_in("cookie"), do: :cookie
  defp parse_param_in(nil), do: nil
  defp parse_param_in(other), do: String.to_atom(other)

  defp parse_param_type(%{"type" => type}), do: String.to_atom(type)
  defp parse_param_type(_), do: nil

  # ── Step 13: Response headers ──────────────────────────────────────────

  @doc false
  @spec parse_response_headers(map()) :: map()
  def parse_response_headers(raw) do
    # Collect from components/headers
    component_headers = parse_component_headers(raw)

    # Also collect unique headers from all responses across operations
    operation_headers = collect_operation_response_headers(raw)

    # Merge: component headers are the canonical source, operation headers fill gaps
    Map.merge(operation_headers, component_headers)
  end

  defp parse_component_headers(raw) do
    raw
    |> get_in(["components", "headers"])
    |> Kernel.||(%{})
    |> Map.new(fn {name, header} ->
      {name, normalize_header(header)}
    end)
  end

  defp collect_operation_response_headers(raw) do
    raw
    |> Map.get("paths", %{})
    |> Enum.flat_map(fn {_path, path_item} ->
      path_item
      |> operation_entries()
      |> Enum.flat_map(&extract_response_header_entries(raw, elem(&1, 1)))
    end)
    |> Map.new()
  end

  defp extract_response_header_entries(raw, operation) do
    operation
    |> Map.get("responses", %{})
    |> Enum.flat_map(fn {_status, response} ->
      resolved = resolve_ref(raw, response)

      resolved
      |> Map.get("headers", %{})
      |> Enum.map(fn {name, header} ->
        {name, raw |> resolve_ref(header) |> normalize_header()}
      end)
    end)
  end

  defp normalize_header(header) do
    schema = Map.get(header, "schema", %{})

    base = %{
      type: parse_param_type(schema),
      description: Map.get(header, "description")
    }

    maybe_put(base, :example, Map.get(schema, "example"))
  end

  # ── Helpers ─────────────────────────────────────────────────────────────

  @doc false
  @spec resolve_ref(map(), map()) :: map()
  def resolve_ref(raw, node) when is_map(node) do
    case Map.get(node, "$ref") do
      nil -> node
      ref -> resolve_ref_path(raw, ref)
    end
  end

  def resolve_ref(_raw, other), do: other

  @doc false
  @spec resolve_ref_path(map(), String.t()) :: map()
  def resolve_ref_path(raw, ref) do
    path = ref |> String.trim_leading("#/") |> String.split("/")
    get_in(raw, path) || %{}
  end

  defp ref_name(ref) do
    ref |> String.split("/") |> List.last()
  end

  defp operation_entries(path_item) do
    http_methods = ~w(get post put delete patch options head trace)

    path_item
    |> Map.take(http_methods)
    |> Map.to_list()
  end

  defp parse_status_code(code) when is_integer(code), do: code

  defp parse_status_code(code) when is_binary(code) do
    case Integer.parse(code) do
      {int, _} -> int
      :error -> code
    end
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, _key, []), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
