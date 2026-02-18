defmodule WhatsApp.Generator.ParityTest do
  @moduledoc """
  Verifies generated code stays in sync with the OpenAPI spec.

  These tests parse the real spec and check that the correct number of
  services, resources, and registry entries were generated. A failure
  here means the spec changed and `mix whatsapp.generate --clean` needs
  to be re-run.
  """
  use ExUnit.Case, async: true

  alias WhatsApp.Generator.OpenAPI

  @spec_path Path.expand("../../../priv/openapi/business-messaging-api_v23.0.json", __DIR__)

  setup_all do
    %{spec: OpenAPI.parse(@spec_path)}
  end

  describe "domain parity" do
    test "spec produces expected number of domains", %{spec: spec} do
      assert length(spec.domains) == 55
    end
  end

  describe "operation parity" do
    test "spec produces expected number of operations", %{spec: spec} do
      op_count =
        Enum.sum(
          Enum.map(spec.domains, fn d ->
            Enum.sum(Enum.map(d.resources, fn r -> length(r.operations) end))
          end)
        )

      assert op_count == 113
    end
  end

  describe "service module parity" do
    test "generated service files match spec resource count", %{spec: spec} do
      expected =
        Enum.sum(Enum.map(spec.domains, fn d -> length(d.resources) end))

      service_dir = Path.expand("../../../lib/whatsapp", __DIR__)

      generated =
        Path.wildcard(Path.join(service_dir, "*/*_service.ex"))
        |> length()

      assert generated == expected
    end

    test "all generated service modules compile" do
      service_dir = Path.expand("../../../lib/whatsapp", __DIR__)

      service_files = Path.wildcard(Path.join(service_dir, "*/*_service.ex"))
      assert service_files != []

      for file <- service_files do
        module_source = File.read!(file)

        assert {:ok, _ast} = Code.string_to_quoted(module_source, file: file),
               "Failed to parse #{file}"
      end
    end
  end

  describe "resource module parity" do
    test "generated resource files exist for all registry entries" do
      resource_dir = Path.expand("../../../lib/whatsapp/resources", __DIR__)

      resource_files =
        Path.wildcard(Path.join(resource_dir, "*.ex"))
        |> Enum.reject(&String.ends_with?(&1, "object_types.ex"))
        |> length()

      assert resource_files > 0
      assert resource_files >= 300
    end
  end

  describe "ObjectTypes registry parity" do
    test "registry has expected entry count" do
      assert map_size(WhatsApp.ObjectTypes.schema_to_module()) == 360
    end

    test "all registry modules are loadable" do
      for {_schema, module} <- WhatsApp.ObjectTypes.schema_to_module() do
        assert Code.ensure_loaded?(module),
               "Module #{inspect(module)} in ObjectTypes registry is not loadable"
      end
    end
  end

  describe "schema parity" do
    test "spec produces expected number of schemas", %{spec: spec} do
      assert map_size(spec.schemas) == 433
    end
  end
end
