defmodule WhatsApp.Generator.OpenAPITest do
  use ExUnit.Case, async: true

  alias WhatsApp.Generator.OpenAPI

  @fixture_path Path.expand("../../fixtures/mini_spec.json", __DIR__)

  setup_all do
    result = OpenAPI.parse(@fixture_path)
    %{result: result}
  end

  # ── 1. Top-level structure ──────────────────────────────────────────────

  describe "parse/1 top-level keys" do
    test "returns all expected top-level keys", %{result: result} do
      expected_keys =
        ~w(info server_url api_version auth tags parameter_groups schemas response_headers domains)a

      assert MapSet.new(Map.keys(result)) == MapSet.new(expected_keys)
    end
  end

  # ── 2. Info extraction ─────────────────────────────────────────────────

  describe "parse_info" do
    test "extracts title", %{result: result} do
      assert result.info.title == "Test WhatsApp API"
    end

    test "extracts description", %{result: result} do
      assert result.info.description == "Test spec for parser"
    end

    test "extracts version", %{result: result} do
      assert result.info.version == "v23.0"
    end

    test "extracts contact", %{result: result} do
      assert result.info.contact.name == "Meta"
      assert result.info.contact.url == "https://developers.facebook.com"
    end

    test "extracts license", %{result: result} do
      assert result.info.license.name == "MIT"
      assert result.info.license.url == "https://opensource.org/licenses/MIT"
    end

    test "extracts terms of service", %{result: result} do
      assert result.info.terms_of_service == "https://developers.facebook.com/terms"
    end
  end

  # ── 3. Server URL and version ──────────────────────────────────────────

  describe "server_url and api_version" do
    test "extracts first server URL", %{result: result} do
      assert result.server_url == "https://graph.facebook.com"
    end

    test "extracts API version from info", %{result: result} do
      assert result.api_version == "v23.0"
    end
  end

  # ── 4. Auth ────────────────────────────────────────────────────────────

  describe "auth" do
    test "detects bearer auth", %{result: result} do
      assert result.auth == :bearer
    end
  end

  # ── 5. Tags ────────────────────────────────────────────────────────────

  describe "parse_tags" do
    test "returns a map keyed by tag name", %{result: result} do
      assert is_map(result.tags)
      assert Map.has_key?(result.tags, "Messages")
      assert Map.has_key?(result.tags, "Media")
    end

    test "preserves Markdown descriptions", %{result: result} do
      assert result.tags["Messages"].description ==
               "## Send Messages\n\nSend various types of messages."
    end

    test "handles empty descriptions", %{result: result} do
      assert result.tags["Examples"].description == ""
    end
  end

  # ── 6. Parameter groups ────────────────────────────────────────────────

  describe "parse_parameter_groups" do
    test "preserves non-standard parameterGroups", %{result: result} do
      assert is_map(result.parameter_groups)
      assert Map.has_key?(result.parameter_groups, "StandardRequestHeaders")
      assert Map.has_key?(result.parameter_groups, "MinimalRequestHeaders")
    end

    test "parameter groups contain refs", %{result: result} do
      standard = result.parameter_groups["StandardRequestHeaders"]
      assert is_list(standard)
      assert length(standard) == 2
    end
  end

  # ── 7. Schemas — basic types ───────────────────────────────────────────

  describe "parse_schemas — basic types" do
    test "parses object schemas with properties", %{result: result} do
      text_msg = result.schemas["TextMessage"]
      assert text_msg.type == :object
      assert text_msg.description == "A text message payload"
      assert text_msg.required == ["body"]
      assert is_list(text_msg.properties)
    end

    test "parses string enum schemas", %{result: result} do
      status = result.schemas["MessageStatus"]
      assert status.type == :string
      assert status.enum == ["accepted", "held_for_quality_assessment", "paused"]
      assert status.description == "Status of a sent message"
    end

    test "parses string const schemas", %{result: result} do
      payload_type = result.schemas["MarketingPayloadType"]
      assert payload_type.type == :string
      assert payload_type.const == "template"
    end
  end

  # ── 8. Schemas — properties and validation ─────────────────────────────

  describe "parse_schemas — properties" do
    test "extracts property type", %{result: result} do
      body = find_property(result.schemas["TextMessage"], "body")
      assert body.type == :string
    end

    test "extracts maxLength constraint", %{result: result} do
      body = find_property(result.schemas["TextMessage"], "body")
      assert body.max_length == 4096
    end

    test "extracts minLength constraint", %{result: result} do
      body = find_property(result.schemas["TextMessage"], "body")
      assert body.min_length == 1
    end

    test "extracts default values", %{result: result} do
      preview = find_property(result.schemas["TextMessage"], "preview_url")
      assert preview.default == false
    end

    test "extracts example values", %{result: result} do
      body = find_property(result.schemas["TextMessage"], "body")
      assert body.example == "Hello!"
    end

    test "extracts format", %{result: result} do
      link = find_property(result.schemas["ImageMessage"], "link")
      assert link.format == :uri
    end

    test "extracts pattern", %{result: result} do
      country = find_property(result.schemas["BusinessProfile"], "country_code")
      assert country.pattern == "^[A-Z]{2}$"
    end

    test "extracts additionalProperties", %{result: result} do
      profile = result.schemas["BusinessProfile"]
      assert profile.additional_properties == false
    end

    test "extracts maxItems on array properties", %{result: result} do
      websites = find_property(result.schemas["BusinessProfile"], "websites")
      assert websites.max_items == 2
      assert websites.type == {:array, :string}
    end

    test "extracts int64 format on properties", %{result: result} do
      id = find_property(result.schemas["BusinessProfile"], "id")
      assert id.format == :int64
      assert id.example == "1234567890123456"
    end

    test "handles array type with items", %{result: result} do
      messages_prop = find_property(result.schemas["SendMessageResponse"], "messages")
      assert messages_prop.type == {:array, :object}
    end
  end

  # ── 9. Schemas — composition ───────────────────────────────────────────

  describe "parse_schemas — composition" do
    test "parses oneOf with $ref", %{result: result} do
      message = result.schemas["Message"]
      assert message.type == :union
      assert "TextMessage" in message.one_of
      assert "ImageMessage" in message.one_of
    end

    test "parses discriminator", %{result: result} do
      message = result.schemas["Message"]
      assert message.discriminator.property_name == "type"
      assert message.discriminator.mapping["text"] == "TextMessage"
      assert message.discriminator.mapping["image"] == "ImageMessage"
    end

    test "parses allOf composition", %{result: result} do
      header = result.schemas["HeaderComponent"]
      assert is_list(header.all_of)
      assert "TemplateComponent" in header.all_of

      # The second element should be an inline schema map
      inline = Enum.find(header.all_of, &is_map/1)
      assert inline.type == :object
      assert is_list(inline.properties)
    end

    test "parses not constraint", %{result: result} do
      sys = result.schemas["IncomingMessageValueSystem"]
      assert sys.not == %{"required" => ["contacts"]}
    end

    test "TemplateComponent has discriminator", %{result: result} do
      tc = result.schemas["TemplateComponent"]
      assert tc.discriminator.property_name == "type"
      assert tc.discriminator.mapping["header"] == "HeaderComponent"
    end
  end

  # ── 10. Domains and grouping ───────────────────────────────────────────

  describe "parse_domains — tag-based grouping" do
    test "returns a list of domain maps", %{result: result} do
      assert is_list(result.domains)
      assert length(result.domains) > 0
    end

    test "Messages domain exists with correct structure", %{result: result} do
      messages = Enum.find(result.domains, &(&1.name == "messages"))
      assert messages != nil
      assert messages.module_name == "Messages"
      assert messages.tag_description =~ "Send Messages"
    end

    test "Media domain exists", %{result: result} do
      media = Enum.find(result.domains, &(&1.name == "media"))
      assert media != nil
      assert media.module_name == "Media"
    end

    test "untagged operations get a domain from path heuristics", %{result: result} do
      # getActiveGroups is untagged and should be grouped by "groups" path segment
      groups = Enum.find(result.domains, &(&1.name == "groups"))
      assert groups != nil
    end
  end

  # ── 11. Operations ─────────────────────────────────────────────────────

  describe "operations — sendMessage" do
    test "sendMessage has correct method and path", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert op.method == :post
      assert op.path == "/{Version}/{Phone-Number-ID}/messages"
    end

    test "sendMessage has correct operation_id", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert op.operation_id == "sendMessage"
    end

    test "sendMessage has function name atom", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert op.name == :send_message
    end

    test "sendMessage has summary and description", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert op.summary == "Send Message."
      assert op.description == "Send a message to a WhatsApp user."
    end

    test "sendMessage has correct tags", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert op.tags == ["Messages"]
    end

    test "sendMessage has security", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert :bearer_auth in op.security
    end

    test "sendMessage has correct content_type", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert op.content_type == "application/json"
    end

    test "sendMessage has request_body_required", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert op.request_body_required == true
    end

    test "sendMessage has request schema ref name", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert op.request_schema == "TextMessage"
    end

    test "sendMessage has response schemas per status code", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert op.response_schemas[200] == "SendMessageResponse"
      assert op.response_schemas[400] == "ErrorResponse"
    end

    test "sendMessage has path params", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert :version in op.path_params
      assert :phone_number_id in op.path_params
    end

    test "sendMessage has request examples", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert length(op.request_examples) == 2

      text_example = Enum.find(op.request_examples, &(&1.name == "text_message"))
      assert text_example.summary == "Send Text Message"
      assert text_example.value["type"] == "text"
    end

    test "sendMessage has response examples", %{result: result} do
      op = find_operation(result, "sendMessage")
      assert Map.has_key?(op.response_examples, 200)
      success = hd(op.response_examples[200])
      assert success.name == "success"
      assert success.value["messages"] == [%{"id" => "wamid.123"}]
    end

    test "sendMessage has merged parameters (path-level + op-level)", %{result: result} do
      op = find_operation(result, "sendMessage")
      param_names = Enum.map(op.parameters, & &1.name)
      assert "Phone-Number-ID" in param_names
      assert "Version" in param_names
    end
  end

  describe "operations — uploadMedia" do
    test "uploadMedia has multipart content type", %{result: result} do
      op = find_operation(result, "uploadMedia")
      assert op.content_type == "multipart/form-data"
    end

    test "uploadMedia has inline request schema name", %{result: result} do
      op = find_operation(result, "uploadMedia")
      assert op.request_schema == "uploadMediaRequest"
    end
  end

  describe "operations — getMediaUrl" do
    test "getMediaUrl has correct method", %{result: result} do
      op = find_operation(result, "getMediaUrl")
      assert op.method == :get
    end

    test "getMediaUrl has operation-level parameter", %{result: result} do
      op = find_operation(result, "getMediaUrl")
      media_param = Enum.find(op.parameters, &(&1.name == "media_id"))
      assert media_param != nil
      assert media_param.in == :path
      assert media_param.required == true
    end

    test "getMediaUrl has no request body", %{result: result} do
      op = find_operation(result, "getMediaUrl")
      assert op.content_type == nil
      assert op.request_schema == nil
      assert op.request_body_required == false
    end
  end

  describe "operations — deleteMedia" do
    test "deleteMedia has correct method", %{result: result} do
      op = find_operation(result, "deleteMedia")
      assert op.method == :delete
    end
  end

  describe "operations — getActiveGroups (untagged)" do
    test "untagged operation is assigned to groups domain", %{result: result} do
      op = find_operation(result, "getActiveGroups")
      assert op != nil
      assert op.tags == []
    end
  end

  # ── 12. Inline schemas ─────────────────────────────────────────────────

  describe "inline schemas" do
    test "inline response schemas get derived names", %{result: result} do
      # uploadMedia has an inline 200 response schema
      assert Map.has_key?(result.schemas, "uploadMediaResponse")
      schema = result.schemas["uploadMediaResponse"]
      assert schema.type == :object
      id_prop = find_property(schema, "id")
      assert id_prop.type == :string
    end

    test "inline request schemas get derived names", %{result: result} do
      # uploadMedia has an inline request schema
      assert Map.has_key?(result.schemas, "uploadMediaRequest")
      schema = result.schemas["uploadMediaRequest"]
      assert schema.type == :object
    end

    test "getMediaUrl inline response schema", %{result: result} do
      assert Map.has_key?(result.schemas, "getMediaUrlResponse")
      schema = result.schemas["getMediaUrlResponse"]
      url_prop = find_property(schema, "url")
      assert url_prop.type == :string
      assert url_prop.format == :uri
    end
  end

  # ── 13. Response headers ───────────────────────────────────────────────

  describe "parse_response_headers" do
    test "extracts component headers", %{result: result} do
      assert Map.has_key?(result.response_headers, "x-fb-trace-id")
      header = result.response_headers["x-fb-trace-id"]
      assert header.type == :string
      assert header.description == "Facebook trace identifier"
    end

    test "extracts header with example", %{result: result} do
      header = result.response_headers["x-fb-request-id"]
      assert header.example == "abc123"
    end

    test "extracts all declared component headers", %{result: result} do
      assert Map.has_key?(result.response_headers, "Access-Control-Allow-Origin")
    end
  end

  # ── 14. $ref resolution ────────────────────────────────────────────────

  describe "$ref resolution" do
    test "resolves response $ref (BadRequest -> ErrorResponse)", %{result: result} do
      op = find_operation(result, "sendMessage")
      # The 400 response refs BadRequest response which contains ErrorResponse schema
      assert op.response_schemas[400] == "ErrorResponse"
    end

    test "resolves parameter $ref (PhoneNumberId)", %{result: result} do
      op = find_operation(result, "sendMessage")
      phone_param = Enum.find(op.parameters, &(&1.name == "Phone-Number-ID"))
      assert phone_param != nil
      assert phone_param.in == :path
      assert phone_param.required == true
      assert phone_param.description == "The phone number ID"
    end

    test "resolves schema $ref in oneOf", %{result: result} do
      message = result.schemas["Message"]
      assert "TextMessage" in message.one_of
      assert "ImageMessage" in message.one_of
    end

    test "resolves schema $ref in allOf", %{result: result} do
      header = result.schemas["HeaderComponent"]
      assert "TemplateComponent" in header.all_of
    end
  end

  # ── Helpers ─────────────────────────────────────────────────────────────

  defp find_property(schema, name) do
    Enum.find(schema.properties, &(&1.name == name))
  end

  defp find_operation(result, operation_id) do
    Enum.find_value(result.domains, fn domain ->
      Enum.find_value(domain.resources, fn resource ->
        Enum.find(resource.operations, &(&1.operation_id == operation_id))
      end)
    end)
  end
end
