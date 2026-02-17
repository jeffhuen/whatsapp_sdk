defmodule WhatsApp.Generator.ResourceGenerator do
  @moduledoc false

  alias WhatsApp.Generator.Naming

  # ── Public API ──────────────────────────────────────────────────────────

  @doc """
  Generate resource struct modules from a parsed OpenAPI spec.

  Takes the result of `WhatsApp.Generator.OpenAPI.parse/1` and an output
  directory path. Writes one `.ex` file per object schema under
  `<output_dir>/lib/whatsapp/resources/`.

  Returns `{:ok, paths}` where `paths` is a list of generated file paths.
  """
  @spec generate(map(), String.t()) :: {:ok, [String.t()]}
  def generate(parsed_spec, output_dir) do
    schemas = parsed_spec.schemas

    paths =
      schemas
      |> Enum.reject(fn {_name, schema} -> skip_schema?(schema) end)
      |> Enum.map(fn {name, schema} ->
        generate_resource(name, schema, schemas, output_dir)
      end)

    {:ok, paths}
  end

  # ── Skip logic ──────────────────────────────────────────────────────────

  # Skip schemas that are:
  # - Pure enum types (string with enum, no properties)
  # - Pure const types (string with const, no properties)
  # - Union types (oneOf without properties)
  # - Schemas without properties and without allOf composition
  defp skip_schema?(%{type: :string, enum: _enum}), do: true
  defp skip_schema?(%{type: :string, const: _const}), do: true
  defp skip_schema?(%{type: :union}), do: true

  defp skip_schema?(%{type: :object} = schema) do
    no_properties?(schema) and not has_all_of?(schema)
  end

  defp skip_schema?(_), do: true

  defp no_properties?(%{properties: props}) when is_list(props) and length(props) > 0, do: false
  defp no_properties?(_), do: true

  defp has_all_of?(%{all_of: all_of}) when is_list(all_of), do: true
  defp has_all_of?(_), do: false

  # ── Single resource generation ──────────────────────────────────────────

  defp generate_resource(name, schema, all_schemas, output_dir) do
    module_name = Naming.resource_module_name(name)
    full_module = Naming.resource_module_name_full(module_name)
    file_path = Path.join(output_dir, Naming.resource_path(module_name))

    {properties, required_fields} = collect_all_properties(schema, all_schemas)

    code = build_module_code(full_module, schema, properties, required_fields, all_schemas)
    formatted = Code.format_string!(code)

    File.mkdir_p!(Path.dirname(file_path))
    File.write!(file_path, [formatted, "\n"])

    file_path
  end

  # ── Property collection (handles allOf) ─────────────────────────────────

  defp collect_all_properties(schema, all_schemas) do
    case Map.get(schema, :all_of) do
      nil ->
        props = Map.get(schema, :properties, [])
        required = Map.get(schema, :required, [])
        {props, required}

      all_of_entries ->
        {props, required} = flatten_all_of(all_of_entries, all_schemas)
        # Also merge in any directly declared properties and required
        direct_props = Map.get(schema, :properties, [])
        direct_required = Map.get(schema, :required, [])

        merged_props = merge_properties(props, direct_props)
        merged_required = Enum.uniq(required ++ direct_required)

        {merged_props, merged_required}
    end
  end

  defp flatten_all_of(entries, all_schemas) do
    Enum.reduce(entries, {[], []}, fn entry, {acc_props, acc_required} ->
      {entry_props, entry_required} = resolve_all_of_entry(entry, all_schemas)
      {merge_properties(acc_props, entry_props), Enum.uniq(acc_required ++ entry_required)}
    end)
  end

  defp resolve_all_of_entry(ref_name, all_schemas) when is_binary(ref_name) do
    case Map.get(all_schemas, ref_name) do
      nil ->
        {[], []}

      referenced_schema ->
        collect_all_properties(referenced_schema, all_schemas)
    end
  end

  defp resolve_all_of_entry(%{} = inline_schema, _all_schemas) do
    props = Map.get(inline_schema, :properties, [])
    required = Map.get(inline_schema, :required, [])
    {props, required}
  end

  # Merge property lists, later entries override earlier ones by name
  defp merge_properties(existing, new) do
    existing_map = Map.new(existing, fn prop -> {prop.name, prop} end)

    new_map = Map.new(new, fn prop -> {prop.name, prop} end)

    merged = Map.merge(existing_map, new_map)

    # Preserve order: existing order, then new properties not in existing
    existing_names = Enum.map(existing, & &1.name)
    new_names = Enum.map(new, & &1.name) -- existing_names

    (existing_names ++ new_names)
    |> Enum.map(&Map.fetch!(merged, &1))
  end

  # ── Code generation ─────────────────────────────────────────────────────

  defp build_module_code(full_module, schema, properties, required_fields, all_schemas) do
    moduledoc = build_moduledoc(schema, properties)
    type_spec = build_type_spec(properties, required_fields, all_schemas)
    enforce_keys = build_enforce_keys(required_fields, properties)
    defstruct_code = build_defstruct(properties, required_fields)

    parts =
      [
        "defmodule #{full_module} do",
        moduledoc,
        "",
        type_spec,
        enforce_keys,
        defstruct_code,
        "end"
      ]
      |> Enum.reject(&is_nil/1)

    Enum.join(parts, "\n")
  end

  # ── @moduledoc ──────────────────────────────────────────────────────────

  defp build_moduledoc(schema, properties) do
    description = Map.get(schema, :description)

    doc_parts =
      [
        description,
        build_enum_docs(properties),
        build_constraint_docs(properties)
      ]
      |> Enum.reject(&is_nil/1)

    if doc_parts == [] do
      ~s(  @moduledoc false)
    else
      content = Enum.join(doc_parts, "\n\n")
      ~s(  @moduledoc """\n#{indent(content, 2)}\n  """)
    end
  end

  defp build_enum_docs(properties) do
    enum_props =
      Enum.filter(properties, fn prop ->
        Map.has_key?(prop, :enum)
      end)

    if enum_props == [] do
      nil
    else
      sections =
        Enum.map(enum_props, fn prop ->
          header = "## `#{prop.name}` Values\n"

          rows =
            Enum.map_join(prop.enum, "\n", fn val ->
              "| `#{val}` |"
            end)

          header <> "| Value |\n| --- |\n" <> rows
        end)

      Enum.join(sections, "\n\n")
    end
  end

  defp build_constraint_docs(properties) do
    constraint_props =
      Enum.filter(properties, fn prop ->
        has_constraints?(prop)
      end)

    if constraint_props == [] do
      nil
    else
      sections =
        Enum.map(constraint_props, fn prop ->
          constraints = collect_constraints(prop)
          "## `#{prop.name}` Constraints\n\n" <> Enum.join(constraints, "\n")
        end)

      Enum.join(sections, "\n\n")
    end
  end

  defp has_constraints?(prop) do
    Enum.any?(
      [:min_length, :max_length, :minimum, :maximum, :pattern, :min_items, :max_items],
      &Map.has_key?(prop, &1)
    )
  end

  defp collect_constraints(prop) do
    []
    |> maybe_add_constraint(prop, :min_length, "Minimum length")
    |> maybe_add_constraint(prop, :max_length, "Maximum length")
    |> maybe_add_constraint(prop, :minimum, "Minimum value")
    |> maybe_add_constraint(prop, :maximum, "Maximum value")
    |> maybe_add_constraint(prop, :min_items, "Minimum items")
    |> maybe_add_constraint(prop, :max_items, "Maximum items")
    |> maybe_add_pattern(prop)
    |> Enum.reverse()
  end

  defp maybe_add_constraint(acc, prop, key, label) do
    case Map.get(prop, key) do
      nil -> acc
      val -> ["- #{label}: #{val}" | acc]
    end
  end

  defp maybe_add_pattern(acc, prop) do
    case Map.get(prop, :pattern) do
      nil -> acc
      pat -> ["- Pattern: `#{pat}`" | acc]
    end
  end

  # ── @type t ─────────────────────────────────────────────────────────────

  defp build_type_spec(properties, required_fields, all_schemas) do
    if properties == [] do
      "  @type t :: %__MODULE__{}"
    else
      fields =
        Enum.map_join(properties, ",\n", fn prop ->
          field_name = prop_field_name(prop.name)
          type = map_type(prop, all_schemas)

          nullable =
            Map.get(prop, :nullable, false) == true or
              prop.name not in required_fields

          full_type = if nullable, do: "#{type} | nil", else: type
          "    #{field_name}: #{full_type}"
        end)

      "  @type t :: %__MODULE__{\n#{fields}\n  }"
    end
  end

  defp map_type(prop, all_schemas) do
    type = prop.type
    format = Map.get(prop, :format)

    do_map_type(type, format, prop, all_schemas)
  end

  defp do_map_type(:string, :date_time, _prop, _schemas), do: "DateTime.t()"
  defp do_map_type(:string, :date, _prop, _schemas), do: "Date.t()"
  defp do_map_type(:string, :time, _prop, _schemas), do: "Time.t()"
  defp do_map_type(:string, _format, _prop, _schemas), do: "String.t()"
  defp do_map_type(:integer, _format, _prop, _schemas), do: "integer()"
  defp do_map_type(:number, _format, _prop, _schemas), do: "float()"
  defp do_map_type(:boolean, _format, _prop, _schemas), do: "boolean()"
  defp do_map_type(:object, _format, _prop, _schemas), do: "map()"

  defp do_map_type({:array, item_type}, _format, _prop, schemas) do
    inner = map_item_type(item_type, schemas)
    "list(#{inner})"
  end

  defp do_map_type({:ref, ref_name}, _format, _prop, _schemas) do
    module_name = Naming.resource_module_name(ref_name)
    "WhatsApp.Resources.#{module_name}.t()"
  end

  defp do_map_type(:union, _format, _prop, _schemas), do: "term()"
  defp do_map_type(nil, _format, _prop, _schemas), do: "term()"
  defp do_map_type(_other, _format, _prop, _schemas), do: "term()"

  defp map_item_type({:ref, ref_name}, _schemas) do
    module_name = Naming.resource_module_name(ref_name)
    "WhatsApp.Resources.#{module_name}.t()"
  end

  defp map_item_type(:string, _schemas), do: "String.t()"
  defp map_item_type(:integer, _schemas), do: "integer()"
  defp map_item_type(:number, _schemas), do: "float()"
  defp map_item_type(:boolean, _schemas), do: "boolean()"
  defp map_item_type(:object, _schemas), do: "map()"
  defp map_item_type(:any, _schemas), do: "term()"
  defp map_item_type(_, _schemas), do: "term()"

  # ── @enforce_keys ───────────────────────────────────────────────────────

  defp build_enforce_keys(required_fields, properties) do
    prop_names = MapSet.new(properties, fn p -> p.name end)

    enforced =
      required_fields
      |> Enum.filter(&(&1 in prop_names))
      |> Enum.map(fn name -> ":#{prop_field_name(name)}" end)

    if enforced == [] do
      nil
    else
      "  @enforce_keys [#{Enum.join(enforced, ", ")}]"
    end
  end

  # ── defstruct ───────────────────────────────────────────────────────────

  defp build_defstruct(properties, required_fields) do
    if properties == [] do
      "  defstruct []"
    else
      fields =
        Enum.map_join(properties, ",\n", fn prop ->
          field = prop_field_name(prop.name)
          default = resolve_default(prop, required_fields)

          case default do
            :no_default -> "    :#{field}"
            value -> "    #{field}: #{inspect(value)}"
          end
        end)

      "  defstruct [\n#{fields}\n  ]"
    end
  end

  defp resolve_default(prop, required_fields) do
    cond do
      Map.has_key?(prop, :const) -> prop.const
      Map.has_key?(prop, :default) -> prop.default
      prop.name in required_fields -> :no_default
      true -> :no_default
    end
  end

  # ── Helpers ─────────────────────────────────────────────────────────────

  defp prop_field_name(name) do
    name
    |> Macro.underscore()
    |> String.replace("-", "_")
    |> String.replace(~r/[^a-z0-9_]/, "")
  end

  defp indent(text, spaces) do
    prefix = String.duplicate(" ", spaces)

    text
    |> String.split("\n")
    |> Enum.map_join("\n", fn line ->
      if String.trim(line) == "" do
        ""
      else
        prefix <> line
      end
    end)
  end
end
