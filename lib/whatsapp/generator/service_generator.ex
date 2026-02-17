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
    spec.domains
    |> Enum.flat_map(fn domain ->
      Enum.map(domain.resources, fn resource ->
        generate_service(domain, resource, output_dir)
      end)
    end)
  end

  # ---------------------------------------------------------------------------
  # File generation
  # ---------------------------------------------------------------------------

  defp generate_service(domain, resource, output_dir) do
    module_name = Naming.service_module_name(domain.module_name, resource.module_name)
    relative_path = Naming.service_path(domain.module_name, resource.module_name)
    full_path = Path.join(output_dir, relative_path)

    source = render_module(module_name, domain.tag_description, resource.operations)
    formatted = Code.format_string!(source) |> IO.iodata_to_binary()

    full_path |> Path.dirname() |> File.mkdir_p!()
    File.write!(full_path, formatted <> "\n")

    {relative_path, module_name}
  end

  # ---------------------------------------------------------------------------
  # Module rendering
  # ---------------------------------------------------------------------------

  defp render_module(module_name, tag_description, operations) do
    moduledoc = render_moduledoc(tag_description)
    functions = Enum.map(operations, &render_function/1) |> Enum.join("\n\n")

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

  defp render_function(operation) do
    func_name = operation.name
    doc = render_doc(operation)
    spec = render_spec(func_name, operation)
    {signature, body} = render_function_body(func_name, operation)

    """
    #{doc}
    #{spec}
    #{signature}
    #{body}
    end
    """
    |> String.trim()
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
      |> Enum.reject(&is_nil/1)
      |> Enum.reject(&(&1 == ""))
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
    path_arg_params = path_arg_params(operation)

    doc_params = path_arg_params ++ query_params

    if doc_params == [] do
      nil
    else
      lines =
        Enum.map(doc_params, fn param ->
          desc = Map.get(param, :description, "")
          type = Map.get(param, :type, "")
          required = if param.required, do: "**required**", else: "optional"
          "  - `#{param.name}` (#{type}, #{required}) - #{desc}"
        end)

      "## Parameters\n\n" <> Enum.join(lines, "\n")
    end
  end

  defp render_example_docs(operation) do
    if operation.request_examples == [] do
      nil
    else
      examples =
        Enum.map(operation.request_examples, fn example ->
          label = example.summary || example.name
          value = inspect(example.value, pretty: true, limit: :infinity)
          "### #{label}\n\n    #{value}"
        end)

      "## Examples\n\n" <> Enum.join(examples, "\n\n")
    end
  end

  # ---------------------------------------------------------------------------
  # @spec
  # ---------------------------------------------------------------------------

  defp render_spec(func_name, operation) do
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

    return_type =
      "{:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}"

    "@spec #{func_name}(#{Enum.join(arg_types, ", ")}) :: #{return_type}"
  end

  # ---------------------------------------------------------------------------
  # Function body
  # ---------------------------------------------------------------------------

  defp render_function_body(func_name, operation) do
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

    # The request call
    method = operation.method

    request_line =
      "    WhatsApp.Client.request(client, :#{method}, #{path_string}#{request_opts})"

    body_lines = body_lines ++ [request_line]

    body = Enum.join(body_lines, "\n")

    {signature, body}
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
end
