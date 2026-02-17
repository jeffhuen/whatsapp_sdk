defmodule WhatsApp.InteractiveTest do
  use ExUnit.Case, async: true

  alias WhatsApp.Interactive

  # ---------- Button messages ----------

  describe "buttons/1,2" do
    test "builds button message with body text and correct type" do
      result = Interactive.buttons("Choose an option:")

      assert result == %{
               "type" => "button",
               "body" => %{"text" => "Choose an option:"},
               "action" => %{"buttons" => []}
             }
    end

    test "includes optional header" do
      result = Interactive.buttons("Body", header: "Header text")

      assert result["header"] == %{"type" => "text", "text" => "Header text"}
    end

    test "includes optional footer" do
      result = Interactive.buttons("Body", footer: "Footer text")

      assert result["footer"] == %{"text" => "Footer text"}
    end

    test "header and footer together" do
      result = Interactive.buttons("Body", header: "H", footer: "F")

      assert result["header"] == %{"type" => "text", "text" => "H"}
      assert result["footer"] == %{"text" => "F"}
      assert result["body"] == %{"text" => "Body"}
    end
  end

  describe "button/3" do
    test "adds up to 3 buttons with id and title" do
      result =
        Interactive.buttons("Pick one")
        |> Interactive.button("id_1", "First")
        |> Interactive.button("id_2", "Second")
        |> Interactive.button("id_3", "Third")

      buttons = result["action"]["buttons"]
      assert length(buttons) == 3

      assert Enum.at(buttons, 0) == %{
               "type" => "reply",
               "reply" => %{"id" => "id_1", "title" => "First"}
             }

      assert Enum.at(buttons, 1) == %{
               "type" => "reply",
               "reply" => %{"id" => "id_2", "title" => "Second"}
             }

      assert Enum.at(buttons, 2) == %{
               "type" => "reply",
               "reply" => %{"id" => "id_3", "title" => "Third"}
             }
    end
  end

  # ---------- List messages ----------

  describe "list/2,3" do
    test "builds list message with body and button text" do
      result = Interactive.list("Main Menu", "View options")

      assert result == %{
               "type" => "list",
               "body" => %{"text" => "Main Menu"},
               "action" => %{"button" => "View options", "sections" => []}
             }
    end
  end

  describe "section/3" do
    test "adds sections with rows" do
      result =
        Interactive.list("Menu", "Options")
        |> Interactive.section("Category A", [
          Interactive.row("r1", "Row 1")
        ])

      sections = result["action"]["sections"]
      assert length(sections) == 1

      assert Enum.at(sections, 0) == %{
               "title" => "Category A",
               "rows" => [%{"id" => "r1", "title" => "Row 1"}]
             }
    end

    test "multiple sections" do
      result =
        Interactive.list("Menu", "Options")
        |> Interactive.section("Section A", [
          Interactive.row("a1", "Item A1")
        ])
        |> Interactive.section("Section B", [
          Interactive.row("b1", "Item B1"),
          Interactive.row("b2", "Item B2")
        ])

      sections = result["action"]["sections"]
      assert length(sections) == 2
      assert Enum.at(sections, 0)["title"] == "Section A"
      assert Enum.at(sections, 1)["title"] == "Section B"
      assert length(Enum.at(sections, 1)["rows"]) == 2
    end
  end

  describe "row/2,3" do
    test "rows include optional description" do
      without_desc = Interactive.row("r1", "Title Only")
      assert without_desc == %{"id" => "r1", "title" => "Title Only"}
      refute Map.has_key?(without_desc, "description")

      with_desc = Interactive.row("r2", "Title", "A description")
      assert with_desc == %{"id" => "r2", "title" => "Title", "description" => "A description"}
    end
  end

  # ---------- CTA URL messages ----------

  describe "cta_url/3,4" do
    test "builds CTA URL with body, display text, and URL" do
      result = Interactive.cta_url("Check this", "Visit", "https://example.com")

      assert result == %{
               "type" => "cta_url",
               "body" => %{"text" => "Check this"},
               "action" => %{
                 "name" => "cta_url",
                 "parameters" => %{
                   "display_text" => "Visit",
                   "url" => "https://example.com"
                 }
               }
             }
    end

    test "includes optional header/footer" do
      result =
        Interactive.cta_url("Body", "Click", "https://example.com",
          header: "Head",
          footer: "Foot"
        )

      assert result["header"] == %{"type" => "text", "text" => "Head"}
      assert result["footer"] == %{"text" => "Foot"}
    end
  end

  # ---------- Flow messages ----------

  describe "flow/3,4" do
    test "builds flow trigger with defaults (navigate)" do
      result = Interactive.flow("Start flow", "flow_123", "Begin")

      assert result == %{
               "type" => "flow",
               "body" => %{"text" => "Start flow"},
               "action" => %{
                 "name" => "flow",
                 "parameters" => %{
                   "flow_id" => "flow_123",
                   "flow_cta" => "Begin",
                   "flow_action" => "navigate"
                 }
               }
             }
    end

    test "custom flow_action" do
      result = Interactive.flow("Body", "f1", "Go", flow_action: "data_exchange")

      assert result["action"]["parameters"]["flow_action"] == "data_exchange"
    end

    test "with flow_action_payload" do
      payload = %{"screen" => "WELCOME", "data" => %{"name" => "Jeff"}}

      result = Interactive.flow("Body", "f1", "Go", flow_action_payload: payload)

      assert result["action"]["parameters"]["flow_action_payload"] == payload
    end
  end

  # ---------- Location request ----------

  describe "location_request/1" do
    test "builds location request message" do
      result = Interactive.location_request("Share your location")

      assert result == %{
               "type" => "location_request_message",
               "body" => %{"text" => "Share your location"},
               "action" => %{"name" => "send_location"}
             }
    end
  end

  # ---------- Product messages ----------

  describe "product/2,3" do
    test "builds single product message" do
      result = Interactive.product("catalog_1", "sku_100")

      assert result == %{
               "type" => "product",
               "action" => %{
                 "catalog_id" => "catalog_1",
                 "product_retailer_id" => "sku_100"
               }
             }
    end

    test "single product with optional body and footer" do
      result = Interactive.product("cat_1", "sku_1", body: "Great product", footer: "Limited")

      assert result["body"] == %{"text" => "Great product"}
      assert result["footer"] == %{"text" => "Limited"}
    end
  end

  describe "product_list/2,3" do
    test "builds product list with sections" do
      result =
        Interactive.product_list("Browse our catalog", "cat_1")
        |> Interactive.product_section("Widgets", ["sku_1", "sku_2"])
        |> Interactive.product_section("Gadgets", ["sku_3"])

      assert result["type"] == "product_list"
      assert result["body"] == %{"text" => "Browse our catalog"}
      assert result["action"]["catalog_id"] == "cat_1"

      sections = result["action"]["sections"]
      assert length(sections) == 2

      assert Enum.at(sections, 0) == %{
               "title" => "Widgets",
               "product_items" => [
                 %{"product_retailer_id" => "sku_1"},
                 %{"product_retailer_id" => "sku_2"}
               ]
             }

      assert Enum.at(sections, 1) == %{
               "title" => "Gadgets",
               "product_items" => [
                 %{"product_retailer_id" => "sku_3"}
               ]
             }
    end
  end

  describe "product_section/3" do
    test "product section contains product items with retailer IDs" do
      result =
        Interactive.product_list("Catalog", "cat_1")
        |> Interactive.product_section("Section", ["id_a", "id_b", "id_c"])

      section = hd(result["action"]["sections"])

      assert section["product_items"] == [
               %{"product_retailer_id" => "id_a"},
               %{"product_retailer_id" => "id_b"},
               %{"product_retailer_id" => "id_c"}
             ]
    end
  end

  # ---------- Build ----------

  describe "build/1" do
    test "build returns the builder map unchanged" do
      builder = Interactive.buttons("Test")
      assert Interactive.build(builder) == builder
    end
  end

  # ---------- Pipeline integration ----------

  describe "pipeline integration" do
    test "full pipeline: buttons -> button -> button -> build produces valid structure" do
      result =
        Interactive.buttons("Choose:")
        |> Interactive.button("yes", "Yes, proceed")
        |> Interactive.button("no", "No, cancel")
        |> Interactive.build()

      assert result["type"] == "button"
      assert result["body"]["text"] == "Choose:"
      assert length(result["action"]["buttons"]) == 2

      [first, second] = result["action"]["buttons"]
      assert first["reply"]["id"] == "yes"
      assert first["reply"]["title"] == "Yes, proceed"
      assert second["reply"]["id"] == "no"
      assert second["reply"]["title"] == "No, cancel"
    end

    test "full pipeline: list -> section -> section -> build produces valid structure" do
      result =
        Interactive.list("Main Menu", "View options")
        |> Interactive.section("Products", [
          Interactive.row("prod_1", "Widget", "Our best widget"),
          Interactive.row("prod_2", "Gadget", "Our best gadget")
        ])
        |> Interactive.section("Services", [
          Interactive.row("svc_1", "Repair")
        ])
        |> Interactive.build()

      assert result["type"] == "list"
      assert result["body"]["text"] == "Main Menu"
      assert result["action"]["button"] == "View options"
      assert length(result["action"]["sections"]) == 2

      [products, services] = result["action"]["sections"]
      assert products["title"] == "Products"
      assert length(products["rows"]) == 2
      assert Enum.at(products["rows"], 0)["description"] == "Our best widget"
      assert services["title"] == "Services"
      assert length(services["rows"]) == 1
    end
  end
end
