defmodule WhatsApp.Generator.NamingTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Generator.Naming

  describe "domain_module_name/1" do
    test "maps known domains" do
      assert Naming.domain_module_name("messages") == "Messages"
      assert Naming.domain_module_name("media") == "Media"
      assert Naming.domain_module_name("templates") == "Templates"
      assert Naming.domain_module_name("phone_numbers") == "PhoneNumbers"
      assert Naming.domain_module_name("business_profiles") == "BusinessProfiles"
      assert Naming.domain_module_name("flows") == "Flows"
      assert Naming.domain_module_name("qr_codes") == "QrCodes"
      assert Naming.domain_module_name("calls") == "Calls"
      assert Naming.domain_module_name("business_management") == "BusinessManagement"
      assert Naming.domain_module_name("groups") == "Groups"
      assert Naming.domain_module_name("webhooks") == "Webhooks"
    end

    test "handles unknown domains by PascalCasing" do
      assert Naming.domain_module_name("new_domain") == "NewDomain"
      assert Naming.domain_module_name("some_other_thing") == "SomeOtherThing"
    end
  end

  describe "resource_module_name/1" do
    test "strips Details suffix" do
      assert Naming.resource_module_name("QrCodeDetails") == "QrCode"
    end

    test "strips Response suffix" do
      assert Naming.resource_module_name("SendMessageResponse") == "SendMessage"
    end

    test "preserves names without known suffixes" do
      assert Naming.resource_module_name("TextMessage") == "TextMessage"
      assert Naming.resource_module_name("WhatsAppBusinessAccount") == "WhatsAppBusinessAccount"
    end
  end

  describe "function_name/1" do
    test "converts camelCase operationId to snake_case atom" do
      assert Naming.function_name("sendMessage") == :send_message
      assert Naming.function_name("getPhoneNumberById") == :get_phone_number_by_id
      assert Naming.function_name("uploadMedia") == :upload_media
      assert Naming.function_name("listFlows") == :list_flows
    end
  end

  describe "service_path/2" do
    test "builds correct file paths" do
      assert Naming.service_path("Messages", "Message") ==
               "lib/whatsapp/messages/message_service.ex"

      assert Naming.service_path("BusinessManagement", "Solution") ==
               "lib/whatsapp/business_management/solution_service.ex"
    end
  end

  describe "resource_path/1" do
    test "builds correct file paths" do
      assert Naming.resource_path("QrCode") == "lib/whatsapp/resources/qr_code.ex"
      assert Naming.resource_path("TextMessage") == "lib/whatsapp/resources/text_message.ex"
    end
  end

  describe "inline schema naming" do
    test "request schema name" do
      assert Naming.inline_request_schema_name("sendMessage") == "sendMessageRequest"
    end

    test "response schema name for 200" do
      assert Naming.inline_response_schema_name("getPhoneNumber", 200) ==
               "getPhoneNumberResponse"
    end

    test "response schema name for non-200" do
      assert Naming.inline_response_schema_name("sendMessage", 400) ==
               "sendMessage400Response"
    end

    test "nested schema name" do
      assert Naming.inline_nested_schema_name("SendMessageRequest", "text") ==
               "SendMessageRequestText"
    end

    test "nested schema name with underscored property" do
      assert Naming.inline_nested_schema_name("SendMessageRequest", "interactive_action") ==
               "SendMessageRequestInteractiveAction"
    end
  end

  describe "resolve_collision/2" do
    test "returns name if no collision" do
      assert Naming.resolve_collision("TextMessage", MapSet.new(["ImageMessage"])) ==
               "TextMessage"
    end

    test "appends suffix on collision" do
      existing = MapSet.new(["TextMessage"])
      assert Naming.resolve_collision("TextMessage", existing) == "TextMessage1"
    end

    test "increments suffix on multiple collisions" do
      existing = MapSet.new(["TextMessage", "TextMessage1"])
      assert Naming.resolve_collision("TextMessage", existing) == "TextMessage2"
    end

    test "handles deeply nested collisions" do
      existing = MapSet.new(["Foo", "Foo1", "Foo2", "Foo3"])
      assert Naming.resolve_collision("Foo", existing) == "Foo4"
    end
  end

  describe "service_module_name/2" do
    test "builds full service module name" do
      assert Naming.service_module_name("Messages", "Message") ==
               "WhatsApp.Messages.MessageService"

      assert Naming.service_module_name("BusinessManagement", "Solution") ==
               "WhatsApp.BusinessManagement.SolutionService"
    end
  end

  describe "resource_module_name_full/1" do
    test "builds full resource module name" do
      assert Naming.resource_module_name_full("QrCode") == "WhatsApp.Resources.QrCode"
      assert Naming.resource_module_name_full("TextMessage") == "WhatsApp.Resources.TextMessage"
    end
  end

  describe "id_source/1" do
    test "client config params" do
      assert Naming.id_source("phone_number_id") == :client_config
      assert Naming.id_source("business_account_id") == :client_config
      assert Naming.id_source("waba_id") == :client_config
    end

    test "function arg params" do
      assert Naming.id_source("media_id") == :function_arg
      assert Naming.id_source("flow_id") == :function_arg
      assert Naming.id_source("qr_code_id") == :function_arg
      assert Naming.id_source("business_id") == :function_arg
      assert Naming.id_source("app_id") == :function_arg
      assert Naming.id_source("group_id") == :function_arg
    end
  end
end
