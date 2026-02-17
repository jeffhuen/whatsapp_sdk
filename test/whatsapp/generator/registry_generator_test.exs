defmodule WhatsApp.Generator.RegistryGeneratorTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Generator.OpenAPI
  alias WhatsApp.Generator.RegistryGenerator

  @fixture_path Path.expand("../../fixtures/mini_spec.json", __DIR__)

  setup_all do
    parsed = OpenAPI.parse(@fixture_path)

    output_dir =
      Path.join(
        System.tmp_dir!(),
        "whatsapp_registry_gen_test_#{System.unique_integer([:positive])}"
      )

    File.rm_rf!(output_dir)
    File.mkdir_p!(output_dir)

    {:ok, path} = RegistryGenerator.generate(parsed, output_dir)

    on_exit(fn -> File.rm_rf!(output_dir) end)

    %{parsed: parsed, output_dir: output_dir, path: path}
  end

  # ── 1. File creation ───────────────────────────────────────────────────

  describe "file creation" do
    test "generates registry file at correct path", %{output_dir: output_dir, path: path} do
      expected = Path.join(output_dir, "lib/whatsapp/object_types.ex")
      assert path == expected
    end

    test "registry file exists on disk", %{path: path} do
      assert File.exists?(path)
    end
  end

  # ── 2. Generated code compilation ──────────────────────────────────────

  describe "generated code" do
    test "compiles as valid Elixir", %{path: path} do
      content = File.read!(path)

      assert {:ok, _} =
               Code.string_to_quoted(content, file: path),
             "Failed to parse registry file"
    end

    test "contains schema_to_module/0 function", %{path: path} do
      content = File.read!(path)
      assert content =~ "def schema_to_module do"
    end

    test "defines WhatsApp.ObjectTypes module", %{path: path} do
      content = File.read!(path)
      assert content =~ "defmodule WhatsApp.ObjectTypes do"
    end

    test "has @moduledoc false", %{path: path} do
      content = File.read!(path)
      assert content =~ "@moduledoc false"
    end

    test "has @spec for schema_to_module/0", %{path: path} do
      content = File.read!(path)
      assert content =~ "@spec schema_to_module()"
    end
  end

  # ── 3. Schema-to-module mappings ───────────────────────────────────────

  describe "schema-to-module mappings" do
    test "maps TextMessage to WhatsApp.Resources.TextMessage", %{path: path} do
      content = File.read!(path)
      assert content =~ ~s("TextMessage" => WhatsApp.Resources.TextMessage)
    end

    test "maps ImageMessage to WhatsApp.Resources.ImageMessage", %{path: path} do
      content = File.read!(path)
      assert content =~ ~s("ImageMessage" => WhatsApp.Resources.ImageMessage)
    end

    test "maps BusinessProfile to WhatsApp.Resources.BusinessProfile", %{path: path} do
      content = File.read!(path)
      assert content =~ ~s("BusinessProfile" => WhatsApp.Resources.BusinessProfile)
    end

    test "maps ErrorResponse with Naming suffix stripping to WhatsApp.Resources.Error", %{
      path: path
    } do
      content = File.read!(path)
      assert content =~ ~s("ErrorResponse" => WhatsApp.Resources.Error)
    end

    test "maps SendMessageResponse with suffix stripping to WhatsApp.Resources.SendMessage", %{
      path: path
    } do
      content = File.read!(path)
      assert content =~ ~s("SendMessageResponse" => WhatsApp.Resources.SendMessage)
    end

    test "maps TemplateComponent to WhatsApp.Resources.TemplateComponent", %{path: path} do
      content = File.read!(path)
      assert content =~ ~s("TemplateComponent" => WhatsApp.Resources.TemplateComponent)
    end

    test "maps HeaderComponent to WhatsApp.Resources.HeaderComponent", %{path: path} do
      content = File.read!(path)
      assert content =~ ~s("HeaderComponent" => WhatsApp.Resources.HeaderComponent)
    end

    test "maps BodyComponent to WhatsApp.Resources.BodyComponent", %{path: path} do
      content = File.read!(path)
      assert content =~ ~s("BodyComponent" => WhatsApp.Resources.BodyComponent)
    end
  end

  # ── 4. Skipped schemas ────────────────────────────────────────────────

  describe "skipped schemas" do
    test "skips enum schemas — MessageStatus is not in the registry", %{path: path} do
      content = File.read!(path)
      refute content =~ ~s("MessageStatus")
    end

    test "skips const schemas — MarketingPayloadType is not in the registry", %{path: path} do
      content = File.read!(path)
      refute content =~ ~s("MarketingPayloadType")
    end

    test "skips union schemas — Message is not in the registry", %{path: path} do
      content = File.read!(path)
      # Message is a oneOf union, should be skipped
      # Check it's not there as a key — but be careful not to match TextMessage/ImageMessage
      refute content =~ ~r/"Message" =>/
    end

    test "skips schemas without properties — IncomingMessageValueSystem is not in the registry",
         %{path: path} do
      content = File.read!(path)
      refute content =~ ~s("IncomingMessageValueSystem")
    end
  end

  # ── 5. Formatting ─────────────────────────────────────────────────────

  describe "formatting" do
    test "generated code is idempotent under Code.format_string!", %{path: path} do
      content = File.read!(path)
      reformatted = Code.format_string!(content) |> IO.iodata_to_binary()
      # The file should have the formatted content plus a trailing newline
      assert String.trim(content) == String.trim(reformatted)
    end
  end

  # ── 6. Return value ───────────────────────────────────────────────────

  describe "return value" do
    test "returns {:ok, path} with a string path", %{path: path} do
      assert is_binary(path)
    end
  end
end
