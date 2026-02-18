defmodule WhatsApp.Generator.ServiceGenerator do
  @moduledoc false

  alias WhatsApp.Generator.Naming

  @doc """
  Generate service module files from a parsed OpenAPI spec.

  Takes the result of `WhatsApp.Generator.OpenAPI.parse/1` and an output
  directory, writes one `.ex` file per domain/resource combination.

  Returns a list of `{path, module_name}` tuples for each generated file.
  """
  @spec generate(map(), String.t()) :: [{String.t(), String.t()}]
  def generate(spec, output_dir) do
    schemas = spec.schemas

    spec.domains
    |> Enum.flat_map(fn domain ->
      Enum.map(domain.resources, fn resource ->
        generate_service(domain, resource, schemas, output_dir)
      end)
    end)
  end

  # ---------------------------------------------------------------------------
  # File generation
  # ---------------------------------------------------------------------------

  defp generate_service(domain, resource, schemas, output_dir) do
    module_name = Naming.service_module_name(domain.module_name, resource.module_name)
    relative_path = Naming.service_path(domain.module_name, resource.module_name)
    full_path = Path.join(output_dir, relative_path)

    source = render_module(module_name, domain.tag_description, resource.operations, schemas)
    formatted = Code.format_string!(source) |> IO.iodata_to_binary()

    full_path |> Path.dirname() |> File.mkdir_p!()
    File.write!(full_path, formatted <> "\n")

    {relative_path, module_name}
  end

  # ---------------------------------------------------------------------------
  # Module rendering
  # ---------------------------------------------------------------------------

  defp render_module(module_name, tag_description, operations, schemas) do
    moduledoc = render_moduledoc(tag_description)
    functions = Enum.map_join(operations, "\n\n", &render_function(&1, schemas))

    """
    defmodule #{module_name} do
      #{moduledoc}

      #{functions}
    end
    """
  end

  defp render_moduledoc(nil), do: ~s(@moduledoc false)
  defp render_moduledoc(""), do: ~s(@moduledoc false)

  defp render_moduledoc(description) do
    escaped = String.replace(description, ~S("""), ~S(\"""))

    """
    @moduledoc \"""
    #{escaped}
    \"""
    """
    |> String.trim()
  end

  # ---------------------------------------------------------------------------
  # Function rendering
  # ---------------------------------------------------------------------------

  defp render_function(operation, schemas) do
    func_name = operation.name
    doc = render_doc(operation)
    response_info = resolve_response_info(operation, schemas)
    spec = render_spec(func_name, operation, response_info)
    {signature, body} = render_function_body(func_name, operation, response_info)

    main_fn =
      """
      #{doc}
      #{spec}
      #{signature}
      #{body}
      end
      """
      |> String.trim()

    case response_info do
      {:list, _module} ->
        stream_fn = render_stream_function(func_name, operation, response_info)
        main_fn <> "\n\n" <> stream_fn

      _ ->
        main_fn
    end
  end

  # ---------------------------------------------------------------------------
  # @doc
  # ---------------------------------------------------------------------------

  defp render_doc(operation) do
    parts =
      [
        operation.summary,
        operation.description,
        render_param_docs(operation),
        render_example_docs(operation)
      ]
      |> Enum.reject(&(is_nil(&1) or &1 == ""))
      |> Enum.join("\n\n")

    if parts == "" do
      "@doc false"
    else
      escaped = String.replace(parts, ~S("""), ~S(\"""))

      """
      @doc \"""
      #{escaped}
      \"""
      """
      |> String.trim()
    end
  end

  defp render_param_docs(operation) do
    params = operation.parameters
    query_params = Enum.filter(params, &(&1.in == :query))
    doc_params = path_arg_params(operation) ++ query_params

    if doc_params == [] do
      nil
    else
      lines = Enum.map(doc_params, &format_param_doc/1)
      "## Parameters\n\n" <> Enum.join(lines, "\n")
    end
  end

  defp format_param_doc(param) do
    desc = Map.get(param, :description, "")
    type = Map.get(param, :type, "")
    required = if param.required, do: "**required**", else: "optional"
    "  - `#{param.name}` (#{type}, #{required}) - #{desc}"
  end

  defp render_example_docs(operation) do
    if operation.request_examples == [] do
      nil
    else
      examples =
        Enum.map(operation.request_examples, fn example ->
          label = example.summary || example.name
          value = inspect(example.value, pretty: true, limit: :infinity)
          value = escape_example_urls(value)
          "### #{label}\n\n    #{value}"
        end)

      "## Examples\n\n" <> Enum.join(examples, "\n\n")
    end
  end

  # Escape angle-bracket URLs like <http(s)://...> that ExDoc would parse as
  # auto-links. Replace angle brackets with backtick-escaped versions.
  defp escape_example_urls(text) do
    Regex.replace(~r/<(http\(s\):\/\/[^>]+)>/, text, fn _full, url -> url end)
  end

  # ---------------------------------------------------------------------------
  # @spec
  # ---------------------------------------------------------------------------

  defp render_spec(func_name, operation, response_info) do
    arg_params = function_arg_path_params(operation)
    has_body = has_request_body?(operation)

    arg_types =
      cond do
        has_body && arg_params != [] ->
          arg_type_list = Enum.map(arg_params, fn _ -> "String.t()" end)
          ["WhatsApp.Client.t()"] ++ arg_type_list ++ ["map()", "keyword()"]

        has_body ->
          ["WhatsApp.Client.t()", "map()", "keyword()"]

        arg_params != [] ->
          arg_type_list = Enum.map(arg_params, fn _ -> "String.t()" end)
          ["WhatsApp.Client.t()"] ++ arg_type_list ++ ["keyword()"]

        true ->
          ["WhatsApp.Client.t()", "keyword()"]
      end

    return_type = spec_return_type(response_info)

    "@spec #{func_name}(#{Enum.join(arg_types, ", ")}) :: #{return_type}"
  end

  defp spec_return_type({:single, module_name}) do
    "{:ok, #{module_name}.t()} | {:ok, #{module_name}.t(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}"
  end

  defp spec_return_type({:list, _module_name}) do
    "{:ok, WhatsApp.Page.t()} | {:ok, WhatsApp.Page.t(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}"
  end

  defp spec_return_type(:raw) do
    "{:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}"
  end

  # ---------------------------------------------------------------------------
  # Function body
  # ---------------------------------------------------------------------------

  defp render_function_body(func_name, operation, response_info) do
    arg_params = function_arg_path_params(operation)
    has_body = has_request_body?(operation)
    config_params = client_config_path_params(operation)
    query_params = Enum.filter(operation.parameters, &(&1.in == :query))

    # Build function arguments
    args =
      cond do
        has_body && arg_params != [] ->
          arg_names = Enum.map(arg_params, &Atom.to_string/1)
          ["client"] ++ arg_names ++ ["params", "opts \\\\ []"]

        has_body ->
          ["client", "params", "opts \\\\ []"]

        arg_params != [] ->
          arg_names = Enum.map(arg_params, &Atom.to_string/1)
          ["client"] ++ arg_names ++ ["opts \\\\ []"]

        true ->
          ["client", "opts \\\\ []"]
      end

    signature = "def #{func_name}(#{Enum.join(args, ", ")}) do"

    # Build body lines
    body_lines = []

    # Config param resolution lines
    config_lines =
      Enum.map(config_params, fn param ->
        param_str = Atom.to_string(param)
        "    #{param_str} = Keyword.get(opts, :#{param_str}, client.#{param_str})"
      end)

    body_lines = body_lines ++ config_lines

    # Query params handling
    query_lines =
      if query_params != [] do
        param_names = Enum.map(query_params, &String.to_atom(&1.name))

        filter_lines =
          Enum.map(param_names, fn name ->
            "{:#{name}, Keyword.get(opts, :#{name})}"
          end)

        [
          "    query_params = [#{Enum.join(filter_lines, ", ")}] |> Enum.reject(fn {_, v} -> is_nil(v) end)"
        ]
      else
        []
      end

    body_lines = body_lines ++ query_lines

    # Build the path string
    path_string = build_path_string(operation)

    # Build request options
    request_opts = build_request_opts(operation, query_params)

    # The request call with deserialization wrapping
    method = operation.method
    request_call = "WhatsApp.Client.request(client, :#{method}, #{path_string}#{request_opts})"

    result_lines = render_result_wrapping(request_call, response_info)
    body_lines = body_lines ++ result_lines

    body = Enum.join(body_lines, "\n")

    {signature, body}
  end

  defp render_result_wrapping(request_call, {:single, module_name}) do
    [
      "    case #{request_call} do",
      "      {:ok, data} -> {:ok, WhatsApp.Deserializer.deserialize(data, #{module_name})}",
      "      {:ok, data, resp} -> {:ok, WhatsApp.Deserializer.deserialize(data, #{module_name}), resp}",
      "      error -> error",
      "    end"
    ]
  end

  defp render_result_wrapping(request_call, {:list, module_name}) do
    [
      "    case #{request_call} do",
      "      {:ok, data} -> {:ok, WhatsApp.Page.from_response(data, &WhatsApp.Deserializer.deserialize(&1, #{module_name}))}",
      "      {:ok, data, resp} -> {:ok, WhatsApp.Page.from_response(data, &WhatsApp.Deserializer.deserialize(&1, #{module_name})), resp}",
      "      error -> error",
      "    end"
    ]
  end

  defp render_result_wrapping(request_call, :raw) do
    ["    #{request_call}"]
  end

  # ---------------------------------------------------------------------------
  # Path building
  # ---------------------------------------------------------------------------

  defp build_path_string(operation) do
    # Replace path parameters with interpolated expressions.
    # The path template has {Version}, {Phone-Number-ID}, {media_id} style params.
    # We replace each with the appropriate interpolation expression.
    result =
      Regex.replace(~r/\{([^}]+)\}/, operation.path, fn _full, param_name ->
        var_name = normalize_param_name(param_name)

        cond do
          var_name == "version" ->
            "\#{client.api_version}"

          Naming.id_source(var_name) == :client_config ->
            "\#{#{var_name}}"

          true ->
            "\#{#{var_name}}"
        end
      end)

    ~s("#{result}")
  end

  defp normalize_param_name(name) do
    name
    |> String.replace("-", "_")
    |> String.downcase()
  end

  # ---------------------------------------------------------------------------
  # Request options
  # ---------------------------------------------------------------------------

  defp build_request_opts(operation, query_params) do
    parts = []

    # Body encoding
    parts =
      case operation.content_type do
        "application/json" -> parts ++ ["json: params"]
        "multipart/form-data" -> parts ++ ["multipart: params"]
        "application/x-www-form-urlencoded" -> parts ++ ["form: params"]
        _ -> parts
      end

    # Query parameters
    parts =
      if query_params != [] do
        parts ++ ["params: query_params"]
      else
        parts
      end

    if parts == [] do
      ",\n      opts"
    else
      ",\n      [#{Enum.join(parts, ", ")}] ++ opts"
    end
  end

  # ---------------------------------------------------------------------------
  # Helpers
  # ---------------------------------------------------------------------------

  defp has_request_body?(operation) do
    operation.content_type != nil
  end

  defp function_arg_path_params(operation) do
    operation.path_params
    |> Enum.reject(&(&1 == :version))
    |> Enum.filter(fn param ->
      Naming.id_source(Atom.to_string(param)) == :function_arg
    end)
  end

  defp client_config_path_params(operation) do
    operation.path_params
    |> Enum.reject(&(&1 == :version))
    |> Enum.filter(fn param ->
      Naming.id_source(Atom.to_string(param)) == :client_config
    end)
  end

  defp path_arg_params(operation) do
    arg_param_names =
      function_arg_path_params(operation)
      |> Enum.map(&Atom.to_string/1)
      |> MapSet.new()

    operation.parameters
    |> Enum.filter(fn p -> p.in == :path && p.name in arg_param_names end)
  end

  # ---------------------------------------------------------------------------
  # Response info resolution
  # ---------------------------------------------------------------------------

  # Determines how to handle the response: {:single, module}, {:list, module}, or :raw.
  # - GET with no function-arg path params = list operation → {:list, item_module}
  # - Other methods with known 200 schema → {:single, module}
  # - Unknown/skipped schema → :raw
  defp resolve_response_info(operation, schemas) do
    schema_name = Map.get(operation.response_schemas || %{}, 200)
    is_list_op = operation.method == :get and function_arg_path_params(operation) == []

    cond do
      is_list_op ->
        resolve_list_response(schema_name, schemas)

      schema_name != nil ->
        resolve_single_response(schema_name, schemas)

      true ->
        :raw
    end
  end

  defp resolve_single_response(schema_name, schemas) do
    case resolve_resource_module(schema_name, schemas) do
      nil -> :raw
      module -> {:single, module}
    end
  end

  defp resolve_list_response(schema_name, schemas) do
    # For list endpoints, try to find the item type from the response schema's
    # "data" property (which is typically {:array, {:ref, "ItemSchema"}}).
    item_module = find_list_item_module(schema_name, schemas)

    case item_module do
      nil -> :raw
      module -> {:list, module}
    end
  end

  defp find_list_item_module(nil, _schemas), do: nil

  defp find_list_item_module(schema_name, schemas) do
    case Map.get(schemas, schema_name) do
      nil ->
        nil

      schema ->
        data_prop = Enum.find(Map.get(schema, :properties, []), &(&1.name == "data"))

        case data_prop do
          %{type: {:array, {:ref, ref_name}}} ->
            resolve_resource_module(ref_name, schemas)

          _ ->
            nil
        end
    end
  end

  defp resolve_resource_module(schema_name, schemas) do
    case Map.get(schemas, schema_name) do
      nil ->
        nil

      schema ->
        if resource_schema?(schema) do
          Naming.resource_module_name_full(Naming.resource_module_name(schema_name))
        else
          nil
        end
    end
  end

  # A schema produces a resource struct if it's an object with properties
  # or has allOf composition. Enums, consts, unions, and empty objects are skipped.
  defp resource_schema?(%{type: :string, enum: _}), do: false
  defp resource_schema?(%{type: :string, const: _}), do: false
  defp resource_schema?(%{type: :union}), do: false

  defp resource_schema?(%{type: :object} = schema) do
    has_props = match?([_ | _], Map.get(schema, :properties, []))
    has_all_of = is_list(Map.get(schema, :all_of))
    has_props or has_all_of
  end

  defp resource_schema?(_), do: false

  # ---------------------------------------------------------------------------
  # Stream companion function for list operations
  # ---------------------------------------------------------------------------

  defp render_stream_function(list_func_name, operation, {:list, module_name}) do
    stream_name = String.replace_prefix(to_string(list_func_name), "list_", "stream_")
    stream_name = String.replace_prefix(stream_name, "get_", "stream_")

    arg_params = function_arg_path_params(operation)
    has_body = has_request_body?(operation)

    args =
      cond do
        has_body && arg_params != [] ->
          arg_names = Enum.map(arg_params, &Atom.to_string/1)
          ["client"] ++ arg_names ++ ["opts \\\\ []"]

        has_body ->
          ["client", "opts \\\\ []"]

        arg_params != [] ->
          arg_names = Enum.map(arg_params, &Atom.to_string/1)
          ["client"] ++ arg_names ++ ["opts \\\\ []"]

        true ->
          ["client", "opts \\\\ []"]
      end

    # Build the call to the list function with same args (minus opts default)
    call_args = Enum.map_join(args, ", ", &String.replace(&1, " \\\\ []", ""))

    """
    @doc "Stream version of `#{list_func_name}/#{length(args)}` that auto-pages through all results."
    @spec #{stream_name}(#{Enum.map_join(args, ", ", fn a -> arg_to_type(a) end)}) :: Enumerable.t() | {:error, WhatsApp.Error.t()}
    def #{stream_name}(#{Enum.join(args, ", ")}) do
      case #{list_func_name}(#{call_args}) do
        {:ok, page} -> WhatsApp.Page.stream(page, client, deserialize_fn: &WhatsApp.Deserializer.deserialize(&1, #{module_name}))
        error -> error
      end
    end
    """
    |> String.trim()
  end

  defp arg_to_type(arg) do
    name = arg |> String.replace(" \\\\ []", "") |> String.trim()

    cond do
      name == "client" -> "WhatsApp.Client.t()"
      name == "params" -> "map()"
      name == "opts" -> "keyword()"
      true -> "String.t()"
    end
  end
end
