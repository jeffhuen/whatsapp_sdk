defmodule WhatsApp.Generator.RegistryGenerator do
  @moduledoc false

  alias WhatsApp.Generator.Naming

  @doc """
  Generate the schema-to-module registry from a parsed OpenAPI spec.

  Takes the result of `WhatsApp.Generator.OpenAPI.parse/1` and an output
  directory path. Writes a single file `lib/whatsapp/object_types.ex`
  containing a map from schema names to their resource modules.

  Returns `{:ok, path}` where `path` is the generated file path.
  """
  @spec generate(map(), String.t()) :: {:ok, String.t()}
  def generate(parsed_spec, output_dir) do
    schemas = parsed_spec.schemas

    mappings =
      schemas
      |> Enum.reject(fn {_name, schema} -> skip_schema?(schema) end)
      |> Enum.sort_by(fn {name, _schema} -> name end)
      |> Enum.map(fn {name, _schema} ->
        module_name = Naming.resource_module_name(name)
        ~s(      "#{name}" => WhatsApp.Resources.#{module_name})
      end)

    mapping_body = Enum.join(mappings, ",\n")

    code = """
    defmodule WhatsApp.ObjectTypes do
      @moduledoc false

      @spec schema_to_module() :: %{String.t() => module()}
      def schema_to_module do
        %{
    #{mapping_body}
        }
      end
    end
    """

    formatted = Code.format_string!(code) |> IO.iodata_to_binary()

    file_path = Path.join(output_dir, "lib/whatsapp/object_types.ex")
    File.mkdir_p!(Path.dirname(file_path))
    File.write!(file_path, [formatted, "\n"])

    {:ok, file_path}
  end

  # ── Skip logic (mirrors ResourceGenerator) ─────────────────────────────

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
end
