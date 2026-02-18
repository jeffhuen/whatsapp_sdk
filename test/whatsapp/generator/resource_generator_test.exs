defmodule WhatsApp.Generator.ResourceGeneratorTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Generator.OpenAPI
  alias WhatsApp.Generator.ResourceGenerator

  @fixture_path Path.expand("../../fixtures/mini_spec.json", __DIR__)

  setup_all do
    parsed = OpenAPI.parse(@fixture_path)

    output_dir =
      Path.join(
        System.tmp_dir!(),
        "whatsapp_resource_gen_test_#{System.unique_integer([:positive])}"
      )

    File.rm_rf!(output_dir)
    File.mkdir_p!(output_dir)

    {:ok, paths} = ResourceGenerator.generate(parsed, output_dir)

    on_exit(fn -> File.rm_rf!(output_dir) end)

    %{parsed: parsed, output_dir: output_dir, paths: paths}
  end

  # ── 1. File creation ───────────────────────────────────────────────────

  describe "file creation" do
    test "generates files for object schemas with properties", %{paths: paths} do
      filenames = Enum.map(paths, &Path.basename/1)
      assert "text_message.ex" in filenames
      assert "image_message.ex" in filenames
      assert "business_profile.ex" in filenames
    end

    test "generates files with Response suffix stripped", %{paths: paths} do
      filenames = Enum.map(paths, &Path.basename/1)
      # Naming.resource_module_name strips "Response" suffix
      assert "send_message.ex" in filenames
      assert "error.ex" in filenames
    end

    test "creates files at correct resource paths", %{output_dir: output_dir, paths: paths} do
      expected_prefix = Path.join(output_dir, "lib/whatsapp/resources/")

      Enum.each(paths, fn path ->
        assert String.starts_with?(path, expected_prefix),
               "Expected #{path} to start with #{expected_prefix}"
      end)
    end

    test "skips pure enum schemas (MessageStatus)", %{paths: paths} do
      filenames = Enum.map(paths, &Path.basename/1)
      refute "message_status.ex" in filenames
    end

    test "skips pure const schemas (MarketingPayloadType)", %{paths: paths} do
      filenames = Enum.map(paths, &Path.basename/1)
      refute "marketing_payload_type.ex" in filenames
    end

    test "skips union schemas (Message oneOf)", %{paths: paths} do
      filenames = Enum.map(paths, &Path.basename/1)
      refute "message.ex" in filenames
    end

    test "skips schemas without properties (IncomingMessageValueSystem)", %{paths: paths} do
      filenames = Enum.map(paths, &Path.basename/1)
      refute "incoming_message_value_system.ex" in filenames
    end
  end

  # ── 2. Generated code compilation ──────────────────────────────────────

  describe "generated code compiles" do
    test "all generated files are valid Elixir", %{paths: paths} do
      Enum.each(paths, fn path ->
        content = File.read!(path)

        assert {:ok, _} =
                 Code.string_to_quoted(content, file: path),
               "Failed to parse #{Path.basename(path)}"
      end)
    end
  end

  # ── 3. Type spec correctness ───────────────────────────────────────────

  describe "type spec — TextMessage" do
    test "body field is String.t() (required, no nil)", %{output_dir: output_dir} do
      content = read_resource(output_dir, "text_message.ex")
      assert content =~ ~r/body: String\.t\(\)/
      # body is required, so it should NOT have | nil
      refute content =~ ~r/body: String\.t\(\) \| nil/
    end

    test "preview_url is boolean() | nil (optional)", %{output_dir: output_dir} do
      content = read_resource(output_dir, "text_message.ex")
      assert content =~ ~r/preview_url: boolean\(\) \| nil/
    end
  end

  describe "type spec — ImageMessage" do
    test "link has String.t() type (format: uri is still string)", %{output_dir: output_dir} do
      content = read_resource(output_dir, "image_message.ex")
      assert content =~ ~r/link: String\.t\(\)/
    end

    test "all fields are optional (| nil)", %{output_dir: output_dir} do
      content = read_resource(output_dir, "image_message.ex")
      assert content =~ ~r/id: String\.t\(\) \| nil/
      assert content =~ ~r/link: String\.t\(\) \| nil/
      assert content =~ ~r/caption: String\.t\(\) \| nil/
    end
  end

  describe "type spec — BusinessProfile" do
    test "websites field is list(String.t())", %{output_dir: output_dir} do
      content = read_resource(output_dir, "business_profile.ex")
      assert content =~ ~r/websites: list\(String\.t\(\)\)/
    end

    test "about field is String.t()", %{output_dir: output_dir} do
      content = read_resource(output_dir, "business_profile.ex")
      assert content =~ ~r/about: String\.t\(\)/
    end
  end

  describe "type spec — SendMessageResponse" do
    test "messages field is list(map())", %{output_dir: output_dir} do
      # Naming strips Response → file is send_message.ex
      content = read_resource(output_dir, "send_message.ex")
      assert content =~ ~r/messages: list\(map\(\)\)/
    end
  end

  # ── 4. @enforce_keys ───────────────────────────────────────────────────

  describe "@enforce_keys" do
    test "TextMessage enforces :body", %{output_dir: output_dir} do
      content = read_resource(output_dir, "text_message.ex")
      assert content =~ ~r/@enforce_keys \[:body\]/
    end

    test "ImageMessage has no enforce_keys (no required fields)", %{output_dir: output_dir} do
      content = read_resource(output_dir, "image_message.ex")
      refute content =~ ~r/@enforce_keys/
    end
  end

  # ── 5. defstruct defaults ──────────────────────────────────────────────

  describe "defstruct defaults" do
    test "TextMessage preview_url defaults to false", %{output_dir: output_dir} do
      content = read_resource(output_dir, "text_message.ex")
      assert content =~ ~r/preview_url: false/
    end

    test "TextMessage body has no default (required)", %{output_dir: output_dir} do
      content = read_resource(output_dir, "text_message.ex")
      assert content =~ ~r/:body/
    end
  end

  # ── 6. allOf composition ───────────────────────────────────────────────

  describe "allOf composition" do
    test "HeaderComponent includes TemplateComponent fields", %{output_dir: output_dir} do
      content = read_resource(output_dir, "header_component.ex")
      # type comes from TemplateComponent
      assert content =~ ~r/type: String\.t\(\)/
      # format and text come from inline schema
      assert content =~ ~r/format: String\.t\(\)/
      assert content =~ ~r/text: String\.t\(\)/
    end

    test "HeaderComponent enforces :type (from TemplateComponent required)", %{
      output_dir: output_dir
    } do
      content = read_resource(output_dir, "header_component.ex")
      assert content =~ ~r/@enforce_keys \[:type\]/
    end

    test "BodyComponent includes TemplateComponent fields", %{output_dir: output_dir} do
      content = read_resource(output_dir, "body_component.ex")
      assert content =~ ~r/type: String\.t\(\)/
      assert content =~ ~r/text: String\.t\(\)/
    end

    test "BodyComponent enforces :type from parent", %{output_dir: output_dir} do
      content = read_resource(output_dir, "body_component.ex")
      assert content =~ ~r/@enforce_keys \[:type\]/
    end
  end

  # ── 7. @moduledoc ─────────────────────────────────────────────────────

  describe "@moduledoc" do
    test "TextMessage has description in moduledoc", %{output_dir: output_dir} do
      content = read_resource(output_dir, "text_message.ex")
      assert content =~ "A text message payload"
    end

    test "ImageMessage has description in moduledoc", %{output_dir: output_dir} do
      content = read_resource(output_dir, "image_message.ex")
      assert content =~ "An image message payload"
    end

    test "SendMessageResponse has no description, gets @moduledoc false", %{
      output_dir: output_dir
    } do
      content = read_resource(output_dir, "send_message.ex")
      assert content =~ "@moduledoc false"
    end
  end

  # ── 8. Enum documentation ─────────────────────────────────────────────

  describe "enum documentation in moduledoc" do
    test "HeaderComponent documents format enum values", %{output_dir: output_dir} do
      content = read_resource(output_dir, "header_component.ex")
      assert content =~ "TEXT"
      assert content =~ "IMAGE"
      assert content =~ "VIDEO"
      assert content =~ "DOCUMENT"
    end
  end

  # ── 9. Constraint documentation ────────────────────────────────────────

  describe "constraint documentation in moduledoc" do
    test "TextMessage documents body constraints", %{output_dir: output_dir} do
      content = read_resource(output_dir, "text_message.ex")
      assert content =~ "Minimum length: 1"
      assert content =~ "Maximum length: 4096"
    end

    test "HeaderComponent documents text maxLength", %{output_dir: output_dir} do
      content = read_resource(output_dir, "header_component.ex")
      assert content =~ "Maximum length: 60"
    end

    test "BusinessProfile documents about constraints", %{output_dir: output_dir} do
      content = read_resource(output_dir, "business_profile.ex")
      assert content =~ "Minimum length: 1"
      assert content =~ "Maximum length: 139"
    end

    test "BusinessProfile documents websites maxItems", %{output_dir: output_dir} do
      content = read_resource(output_dir, "business_profile.ex")
      assert content =~ "Maximum items: 2"
    end

    test "BusinessProfile documents country_code pattern", %{output_dir: output_dir} do
      content = read_resource(output_dir, "business_profile.ex")
      assert content =~ "Pattern: `^[A-Z]{2}$`"
    end
  end

  # ── 10. Module name correctness ────────────────────────────────────────

  describe "module naming" do
    test "TextMessage gets WhatsApp.Resources.TextMessage module", %{output_dir: output_dir} do
      content = read_resource(output_dir, "text_message.ex")
      assert content =~ "defmodule WhatsApp.Resources.TextMessage do"
    end

    test "ErrorResponse module name strips Response suffix", %{output_dir: output_dir} do
      content = read_resource(output_dir, "error.ex")
      assert content =~ "defmodule WhatsApp.Resources.Error do"
    end

    test "SendMessageResponse module name strips Response suffix", %{output_dir: output_dir} do
      content = read_resource(output_dir, "send_message.ex")
      assert content =~ "defmodule WhatsApp.Resources.SendMessage do"
    end
  end

  # ── 11. Inline schemas ─────────────────────────────────────────────────

  describe "inline schemas" do
    test "generates resource for uploadMediaRequest", %{paths: paths} do
      filenames = Enum.map(paths, &Path.basename/1)
      assert "upload_media_request.ex" in filenames
    end

    test "generates resource for uploadMediaResponse (stripped to upload_media.ex)", %{
      paths: paths
    } do
      filenames = Enum.map(paths, &Path.basename/1)
      # Naming.resource_module_name strips "Response" suffix
      assert "upload_media.ex" in filenames
    end

    test "uploadMediaResponse has id field", %{output_dir: output_dir} do
      # File is upload_media.ex after Response stripping
      content = read_resource(output_dir, "upload_media.ex")
      assert content =~ ~r/id: String\.t\(\)/
    end
  end

  # ── 12. Return value ───────────────────────────────────────────────────

  describe "return value" do
    test "returns {:ok, paths} tuple", %{paths: paths} do
      assert is_list(paths)
      assert paths != []
    end

    test "all returned paths exist on disk", %{paths: paths} do
      Enum.each(paths, fn path ->
        assert File.exists?(path), "Expected file at #{path}"
      end)
    end
  end

  # ── Helpers ─────────────────────────────────────────────────────────────

  defp read_resource(output_dir, filename) do
    Path.join([output_dir, "lib", "whatsapp", "resources", filename])
    |> File.read!()
  end
end
