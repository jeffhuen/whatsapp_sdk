defmodule Mix.Tasks.Whatsapp.Generate do
  @shortdoc "Generate WhatsApp SDK modules from OpenAPI spec"

  @moduledoc """
  Generate WhatsApp SDK service, resource, and registry modules from an
  OpenAPI specification.

      $ mix whatsapp.generate
      $ mix whatsapp.generate --clean
      $ mix whatsapp.generate --dry-run
      $ mix whatsapp.generate --stats

  ## Options

    * `--clean` - delete previously generated files before regenerating
    * `--dry-run` - parse and compute what would be generated without writing files
    * `--stats` - print generation statistics after generating

  The task looks for the first `.json` file in `priv/openapi/` and uses it
  as the OpenAPI specification source.
  """

  use Mix.Task

  alias WhatsApp.Generator.OpenAPI
  alias WhatsApp.Generator.RegistryGenerator
  alias WhatsApp.Generator.ResourceGenerator
  alias WhatsApp.Generator.ServiceGenerator

  @switches [clean: :boolean, dry_run: :boolean, stats: :boolean]

  @impl Mix.Task
  def run(args) do
    {opts, _rest} = OptionParser.parse!(args, strict: @switches)

    spec_path = find_spec_file!()
    parsed = OpenAPI.parse(spec_path)
    output_dir = File.cwd!()

    if opts[:dry_run] do
      run_dry(parsed)
    else
      if opts[:clean], do: clean!(parsed, output_dir)

      {service_results, resource_paths, registry_path} = generate_all(parsed, output_dir)

      if opts[:stats] || opts[:clean] do
        print_stats(service_results, resource_paths, registry_path)
      end
    end
  end

  # ── Spec discovery ─────────────────────────────────────────────────────

  defp find_spec_file! do
    priv_dir = Path.join(File.cwd!(), "priv/openapi")

    case Path.wildcard(Path.join(priv_dir, "*.json")) do
      [first | _] ->
        first

      [] ->
        Mix.raise("No OpenAPI spec found in priv/openapi/. Place a .json spec file there.")
    end
  end

  # ── Generation ─────────────────────────────────────────────────────────

  defp generate_all(parsed, output_dir) do
    service_results = ServiceGenerator.generate(parsed, output_dir)
    {:ok, resource_paths} = ResourceGenerator.generate(parsed, output_dir)
    {:ok, registry_path} = RegistryGenerator.generate(parsed, output_dir)

    {service_results, resource_paths, registry_path}
  end

  # ── Dry run ────────────────────────────────────────────────────────────

  defp run_dry(parsed) do
    service_count =
      parsed.domains
      |> Enum.flat_map(fn domain -> domain.resources end)
      |> length()

    resource_count =
      parsed.schemas
      |> Enum.reject(fn {_name, schema} -> skip_schema?(schema) end)
      |> length()

    registry_count = 1
    total = service_count + resource_count + registry_count

    Mix.shell().info("""
    Dry run — would generate:
      Services: #{service_count} files
      Resources: #{resource_count} files
      Registry: #{registry_count} file
      Total: #{total} files
    """)
  end

  # ── Clean ──────────────────────────────────────────────────────────────

  defp clean!(parsed, output_dir) do
    # Remove generated resource directory
    resources_dir = Path.join(output_dir, "lib/whatsapp/resources")
    _ = File.rm_rf!(resources_dir)

    # Remove generated service directories (one per domain)
    Enum.each(parsed.domains, fn domain ->
      dir_name = Macro.underscore(domain.module_name)
      service_dir = Path.join(output_dir, "lib/whatsapp/#{dir_name}")
      _ = File.rm_rf!(service_dir)
    end)

    # Remove generated registry file
    registry_path = Path.join(output_dir, "lib/whatsapp/object_types.ex")
    _ = File.rm(registry_path)
    :ok
  end

  # ── Stats ──────────────────────────────────────────────────────────────

  defp print_stats(service_results, resource_paths, _registry_path) do
    service_count = length(service_results)
    resource_count = length(resource_paths)
    registry_count = 1
    total = service_count + resource_count + registry_count

    Mix.shell().info("""
    Generated WhatsApp SDK modules:
      Services: #{service_count} files
      Resources: #{resource_count} files
      Registry: #{registry_count} file
      Total: #{total} files
    """)
  end

  # ── Skip logic (mirrors ResourceGenerator) ─────────────────────────────

  defp skip_schema?(%{type: :string, enum: _enum}), do: true
  defp skip_schema?(%{type: :string, const: _const}), do: true
  defp skip_schema?(%{type: :union}), do: true

  defp skip_schema?(%{type: :object} = schema) do
    no_properties?(schema) and not has_all_of?(schema)
  end

  defp skip_schema?(_), do: true

  defp no_properties?(%{properties: [_ | _]}), do: false
  defp no_properties?(_), do: true

  defp has_all_of?(%{all_of: all_of}) when is_list(all_of), do: true
  defp has_all_of?(_), do: false
end
