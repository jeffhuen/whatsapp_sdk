# Interactive Messages

This guide covers building interactive WhatsApp messages — buttons, lists, CTA URLs, flows, location requests, and product messages.

## Overview

`WhatsApp.Interactive` provides a functional pipeline API for constructing interactive message payloads. Builders produce plain maps that you send as the `"interactive"` field in a message request.

## Quick Reply Buttons

Up to 3 buttons per message. Each button has an ID (for your callback) and a title (max 20 bytes).

```elixir
alias WhatsApp.Interactive

payload =
  Interactive.buttons("Would you like to proceed?")
  |> Interactive.button("confirm", "Yes, proceed")
  |> Interactive.button("cancel", "No, cancel")
  |> Interactive.build()

# Send the interactive message
WhatsApp.Client.request(client, :post,
  "/v23.0/#{client.phone_number_id}/messages",
  json: %{
    "messaging_product" => "whatsapp",
    "to" => recipient,
    "type" => "interactive",
    "interactive" => payload
  }
)
```

Add optional headers and footers:

```elixir
Interactive.buttons("Choose an option:", header: "Important", footer: "Reply to continue")
|> Interactive.button("opt_a", "Option A")
|> Interactive.button("opt_b", "Option B")
|> Interactive.build()
```

## List Messages

Lists let users pick from a scrollable menu with sections and rows.

```elixir
alias WhatsApp.Interactive

payload =
  Interactive.list("What would you like to order?", "View Menu")
  |> Interactive.section("Drinks", [
    Interactive.row("espresso", "Espresso", "$3.50"),
    Interactive.row("latte", "Latte", "$4.50"),
    Interactive.row("cappuccino", "Cappuccino", "$4.00")
  ])
  |> Interactive.section("Food", [
    Interactive.row("croissant", "Croissant", "$2.50"),
    Interactive.row("muffin", "Muffin", "$3.00")
  ])
  |> Interactive.build()
```

The second argument to `list/3` is the button text that opens the list. Rows support an optional description (third argument to `row/3`).

## CTA URL Messages

Send a call-to-action button that opens a URL:

```elixir
payload =
  Interactive.cta_url(
    "Check out our latest products!",
    "Shop Now",
    "https://example.com/shop"
  )
```

With header and footer:

```elixir
Interactive.cta_url(
  "We have new arrivals this week.",
  "Browse Collection",
  "https://example.com/new",
  header: "New Arrivals",
  footer: "Free shipping on orders over $50"
)
```

## Flow Messages

Trigger a WhatsApp Flow (interactive forms and screens):

```elixir
payload =
  Interactive.flow(
    "Complete your registration",
    "flow_id_12345",
    "Start Registration"
  )
```

With a custom action and payload:

```elixir
Interactive.flow(
  "Update your preferences",
  "flow_id_67890",
  "Update Now",
  flow_action: "navigate",
  flow_action_payload: %{"screen" => "preferences", "user_id" => "123"}
)
```

## Location Request

Ask the user to share their location:

```elixir
payload = Interactive.location_request("Please share your delivery address")
```

## Product Messages

### Single Product

Display a product from your catalog:

```elixir
payload = Interactive.product("catalog_123", "SKU_001",
  body: "Check out this item!",
  footer: "Limited stock"
)
```

### Multi-Product List

Show a curated selection of products:

```elixir
payload =
  Interactive.product_list("Browse our top picks", "catalog_123",
    header: "Featured Products"
  )
  |> Interactive.product_section("Electronics", ["SKU_001", "SKU_002", "SKU_003"])
  |> Interactive.product_section("Accessories", ["SKU_010", "SKU_011"])
  |> Interactive.build()
```

## Sending Interactive Messages

All builders produce a map. Wrap it in the standard message envelope:

```elixir
defmodule MyApp.Messaging do
  def send_interactive(client, to, interactive_payload) do
    WhatsApp.Client.request(client, :post,
      "/v23.0/#{client.phone_number_id}/messages",
      json: %{
        "messaging_product" => "whatsapp",
        "to" => to,
        "type" => "interactive",
        "interactive" => interactive_payload
      }
    )
  end
end
```

## Builder Pattern

Every builder returns a plain map. `build/1` is an identity function — it exists for pipeline readability. You can inspect or modify the map at any point:

```elixir
payload =
  Interactive.buttons("Pick one")
  |> Interactive.button("a", "Option A")
  |> IO.inspect(label: "before build")
  |> Interactive.build()
```
