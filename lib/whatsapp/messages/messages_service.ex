defmodule WhatsApp.Messages.MessagesService do
  @moduledoc """
  Use the **`/{{Phone-Number-ID}}/messages`** endpoint to send text messages, media (audio, documents, images, and video), and message templates to your customers. For more information relating to the messages you can send, see [Messages](#1f4f7644-cc97-40b5-b8e4-c19da268fff1).

  Messages are identified by a unique ID. You can track message status in the Webhooks through its ID. You could also mark an incoming message as read through the **`/{{Phone-Number-ID}}/messages`** endpoint.

  ## Prerequisites

  *   [User Access Token](https://developers.facebook.com/docs/facebook-login/access-tokens#usertokens) with **`whatsapp_business_messaging`** permission
  *   `phone-number-id` for your registered WhatsApp account. See [Get Phone Number](#c72d9c17-554d-4ae1-8f9e-b28a94010b28).
  """

  @doc """
  Send Message.

  Send Message.

  ## Examples

  ### Send Text Message with Preview URL

      %{
    "messaging_product" => "whatsapp",
    "text" => %{
      "body" => "Please visit https://youtu.be/hpltvTEiRrY.",
      "preview_url" => true
    },
    "to" => "{{Recipient-Phone-Number}}"
  }

  ### Send Catalog Message

      %{
    "interactive" => %{
      "action" => %{
        "name" => "catalog_message",
        "parameters" => %{"thumbnail_product_retailer_id" => "2lc20305pt"}
      },
      "body" => %{
        "text" => "Hello! Thanks for your interest. Ordering is easy. Just visit our catalog and add items to purchase."
      },
      "footer" => %{"text" => "Best grocery deals on WhatsApp!"},
      "type" => "catalog_message"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "+16505551234",
    "type" => "interactive"
  }

  ### Send Image Message by ID

      %{
    "image" => %{"id" => "<IMAGE_OBJECT_ID>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "image"
  }

  ### Send Reply to List Message

      %{
    "context" => %{"message_id" => "<MSGID_OF_PREV_MSG>"},
    "interactive" => %{
      "action" => %{
        "button" => "<BUTTON_TEXT>",
        "sections" => [
          %{
            "rows" => [
              %{
                "description" => "<SECTION_1_ROW_1_DESC>",
                "id" => "<LIST_SECTION_1_ROW_1_ID>",
                "title" => "<SECTION_1_ROW_1_TITLE>"
              },
              %{
                "description" => "<SECTION_1_ROW_2_DESC>",
                "id" => "<LIST_SECTION_1_ROW_2_ID>",
                "title" => "<SECTION_1_ROW_2_TITLE>"
              }
            ],
            "title" => "<LIST_SECTION_1_TITLE>"
          },
          %{
            "rows" => [
              %{
                "description" => "<SECTION_2_ROW_1_DESC>",
                "id" => "<LIST_SECTION_2_ROW_1_ID>",
                "title" => "<SECTION_2_ROW_1_TITLE>"
              },
              %{
                "description" => "<SECTION_2_ROW_2_DESC>",
                "id" => "<LIST_SECTION_2_ROW_2_ID>",
                "title" => "<SECTION_2_ROW_2_TITLE>"
              }
            ],
            "title" => "<LIST_SECTION_2_TITLE>"
          }
        ]
      },
      "body" => %{"text" => "<BODY_TEXT>"},
      "footer" => %{"text" => "<FOOTER_TEXT>"},
      "header" => %{"text" => "<HEADER_TEXT>", "type" => "text"},
      "type" => "list"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}"
  }

  ### Send Multi-Product Message

      %{
    "interactive" => %{
      "action" => %{
        "catalog_id" => "146265584024623",
        "sections" => [
          %{
            "product_items" => [
              %{"product_retailer_id" => "<YOUR_PRODUCT1_SKU_IN_CATALOG>"},
              %{"product_retailer_id" => "<YOUR_SECOND_PRODUCT1_SKU_IN_CATALOG>"}
            ],
            "title" => "<SECTION1_TITLE>"
          },
          %{
            "product_items" => [
              %{"product_retailer_id" => "<YOUR_PRODUCT2_SKU_IN_CATALOG>"},
              %{"product_retailer_id" => "<YOUR_SECOND_PRODUCT2_SKU_IN_CATALOG>"}
            ],
            "title" => "<SECTION2_TITLE>"
          }
        ]
      },
      "body" => %{"text" => "<YOUR_TEXT_BODY_CONTENT>"},
      "footer" => %{"text" => "<YOUR_TEXT_FOOTER_CONTENT>"},
      "header" => %{
        "text" => "<YOUR_TEXT_HEADER_CONTENT>",
        "type" => "<HEADER_TYPE>"
      },
      "type" => "product_list"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Reply to Audio Message by URL

      %{
    "audio" => %{"link" => "http(s)://audio-url"},
    "context" => %{"message_id" => "<MSGID_OF_MSG_YOU_ARE_REPLYING_TO>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "audio"
  }

  ### Send Reply to Text Message

      %{
    "context" => %{"message_id" => "<MSGID_OF_PREV_MSG>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "text" => %{"body" => "<TEXT_MSG_CONTENT>", "preview_url" => false},
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "text"
  }

  ### Send List Message

      %{
    "interactive" => %{
      "action" => %{
        "button" => "<BUTTON_TEXT>",
        "sections" => [
          %{
            "rows" => [
              %{
                "description" => "<SECTION_1_ROW_1_DESC>",
                "id" => "<LIST_SECTION_1_ROW_1_ID>",
                "title" => "<SECTION_1_ROW_1_TITLE>"
              },
              %{
                "description" => "<SECTION_1_ROW_2_DESC>",
                "id" => "<LIST_SECTION_1_ROW_2_ID>",
                "title" => "<SECTION_1_ROW_2_TITLE>"
              }
            ],
            "title" => "<LIST_SECTION_1_TITLE>"
          },
          %{
            "rows" => [
              %{
                "description" => "<SECTION_2_ROW_1_DESC>",
                "id" => "<LIST_SECTION_2_ROW_1_ID>",
                "title" => "<SECTION_2_ROW_1_TITLE>"
              },
              %{
                "description" => "<SECTION_2_ROW_2_DESC>",
                "id" => "<LIST_SECTION_2_ROW_2_ID>",
                "title" => "<SECTION_2_ROW_2_TITLE>"
              }
            ],
            "title" => "<LIST_SECTION_2_TITLE>"
          }
        ]
      },
      "body" => %{"text" => "<BODY_TEXT>"},
      "footer" => %{"text" => "<FOOTER_TEXT>"},
      "header" => %{"text" => "<HEADER_TEXT>", "type" => "text"},
      "type" => "list"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Audio Message by URL

      %{
    "audio" => %{"link" => "<http(s)://audio-url>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "audio"
  }

  ### Send Flow Template Message

      %{
    "messaging_product" => "whatsapp",
    "template" => %{
      "components" => [
        %{
          "index" => "0",
          "parameters" => [
            %{
              "action" => %{
                "flow_action_data" => %{"<CUSTOM_KEY>" => "<CUSTOM_VALUE>"},
                "flow_token" => "<FLOW_TOKEN>"
              },
              "type" => "action"
            }
          ],
          "sub_type" => "flow",
          "type" => "button"
        }
      ],
      "language" => %{"code" => "en_US"},
      "name" => "<TEMPLATE_NAME>"
    },
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "template"
  }

  ### Send Location Message

      %{
    "location" => %{
      "address" => "1 Hacker Way, Menlo Park, CA 94025",
      "latitude" => 37.758056,
      "longitude" => -122.425332,
      "name" => "META HQ"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "location"
  }

  ### Send Image Message by URL

      %{
    "image" => %{"link" => "http(s)://image-url"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "image"
  }

  ### Send Reply with Reaction Message

      %{
    "messaging_product" => "whatsapp",
    "reaction" => %{"emoji" => "😀", "message_id" => "wamid.HBgLM..."},
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "reaction"
  }

  ### Send Reply Button

      %{
    "interactive" => %{
      "action" => %{
        "buttons" => [
          %{
            "reply" => %{
              "id" => "<UNIQUE_BUTTON_ID_1>",
              "title" => "<BUTTON_TITLE_1>"
            },
            "type" => "reply"
          },
          %{
            "reply" => %{
              "id" => "<UNIQUE_BUTTON_ID_2>",
              "title" => "<BUTTON_TITLE_2>"
            },
            "type" => "reply"
          }
        ]
      },
      "body" => %{"text" => "<BUTTON_TEXT>"},
      "type" => "button"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Document Message by URL

      %{
    "document" => %{
      "caption" => "<DOCUMENT-CAPTION-TEXT>",
      "link" => "<http(s)://document-url>"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "document"
  }

  ### Send Sample Text Message

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "template" => %{
      "components" => [
        %{
          "parameters" => [
            %{"text" => "text-string", "type" => "text"},
            %{
              "currency" => %{
                "amount_1000" => 100990,
                "code" => "USD",
                "fallback_value" => "$100.99"
              },
              "type" => "currency"
            },
            %{
              "date_time" => %{
                "calendar" => "GREGORIAN",
                "day_of_month" => 25,
                "day_of_week" => 5,
                "fallback_value" => "February 25, 1977",
                "hour" => 15,
                "minute" => 33,
                "month" => 2,
                "year" => 1977
              },
              "type" => "date_time"
            }
          ],
          "type" => "body"
        }
      ],
      "language" => %{"code" => "language-and-locale-code"},
      "name" => "template-name"
    },
    "to" => "16315555555",
    "type" => "template"
  }

  ### Send Reply to Sticker Message by URL

      %{
    "context" => %{"message_id" => "<MSGID_OF_MSG_YOU_ARE_REPLYING_TO>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "sticker" => %{"link" => "<http(s)://sticker-url>"},
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "sticker"
  }

  ### Send Reply to Image Message by ID

      %{
    "context" => %{"message_id" => "<MSGID_OF_PREV_MSG>"},
    "image" => %{"id" => "<IMAGE_OBJECT_ID>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "image"
  }

  ### Send Published Flow by Name

      %{
    "interactive" => %{
      "action" => %{
        "name" => "flow",
        "parameters" => %{
          "flow_action" => "navigate",
          "flow_action_payload" => %{
            "data" => %{"<CUSTOM_KEY>" => "<CUSTOM_VALUE>"},
            "screen" => "<SCREEN_ID>"
          },
          "flow_cta" => "Open Flow!",
          "flow_message_version" => "3",
          "flow_name" => "{{Flow-Name}}",
          "flow_token" => "<FLOW_TOKEN>"
        }
      },
      "body" => %{"text" => "<BODY_TEXT>"},
      "footer" => %{"text" => "<FOOTER_TEXT>"},
      "header" => %{"text" => "<HEADER_TEXT>", "type" => "text"},
      "type" => "flow"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Text Message

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "text" => %{"body" => "text-message-content", "preview_url" => false},
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "text"
  }

  ### Send Draft Flow by ID

      %{
    "interactive" => %{
      "action" => %{
        "name" => "flow",
        "parameters" => %{
          "flow_action" => "navigate",
          "flow_action_payload" => %{
            "data" => %{"<CUSTOM_KEY>" => "<CUSTOM_VALUE>"},
            "screen" => "<SCREEN_ID>"
          },
          "flow_cta" => "Not shown in draft mode",
          "flow_id" => "{{Flow-ID}}",
          "flow_message_version" => "3",
          "flow_token" => "<FLOW_TOKEN>",
          "mode" => "draft"
        }
      },
      "body" => %{"text" => "Not shown in draft mode"},
      "footer" => %{"text" => "Not shown in draft mode"},
      "header" => %{"text" => "Not shown in draft mode", "type" => "text"},
      "type" => "flow"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Video Message by ID

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "video",
    "video" => %{"caption" => "<VIDEO_CAPTION_TEXT>", "id" => "<VIDEO_OBJECT_ID>"}
  }

  ### Send Reply to Audio Message by ID

      %{
    "audio" => %{"id" => "<AUDIO_OBJECT_ID>"},
    "context" => %{"message_id" => "<MSGID_OF_MSG_YOU_ARE_REPLYING_TO>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "audio"
  }

  ### Send Order Details Message

      %{
    "interactive" => %{
      "action" => %{
        "name" => "review_and_pay",
        "parameters" => %{
          "currency" => "INR",
          "order" => %{
            "discount" => %{
              "description" => "optional_text",
              "discount_program_name" => "optional_text",
              "offset" => 100,
              "value" => 100
            },
            "items" => [
              %{
                "amount" => %{"offset" => 100, "value" => 1500},
                "name" => "bread",
                "quantity" => 1,
                "retailer_id" => "1234567",
                "sale_amount" => %{"offset" => 100, "value" => 1000}
              }
            ],
            "shipping" => %{
              "description" => "optional_text",
              "offset" => 100,
              "value" => 100
            },
            "status" => "pending",
            "subtotal" => %{"offset" => 100, "value" => 1000},
            "tax" => %{
              "description" => "optional_text",
              "offset" => 100,
              "value" => 100
            }
          },
          "payment_configuration" => "my-payment-config-name",
          "payment_type" => "upi",
          "reference_id" => "unique-reference-id",
          "total_amount" => %{"offset" => 100, "value" => 1100},
          "type" => "digital-goods"
        }
      },
      "body" => %{"text" => "your-text-body-content"},
      "footer" => %{"text" => "your-text-footer-content"},
      "header" => %{
        "image" => %{
          "link" => "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Home_made_sour_dough_bread.jpg/640px-Home_made_sour_dough_bread.jpg"
        },
        "type" => "image"
      },
      "type" => "order_details"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-WA-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Catalog Template Message

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "template" => %{
      "components" => [
        %{
          "parameters" => [
            %{"text" => "100", "type" => "text"},
            %{"text" => "400", "type" => "text"},
            %{"text" => "3", "type" => "text"}
          ],
          "type" => "body"
        },
        %{
          "index" => 0,
          "parameters" => [
            %{
              "action" => %{"thumbnail_product_retailer_id" => "2lc20305pt"},
              "type" => "action"
            }
          ],
          "sub_type" => "CATALOG",
          "type" => "button"
        }
      ],
      "language" => %{"code" => "en_US"},
      "name" => "intro_catalog_offer"
    },
    "to" => "+16505551234",
    "type" => "template"
  }

  ### Send Published Flow by ID

      %{
    "interactive" => %{
      "action" => %{
        "name" => "flow",
        "parameters" => %{
          "flow_action" => "navigate",
          "flow_action_payload" => %{
            "data" => %{"<CUSTOM_KEY>" => "<CUSTOM_VALUE>"},
            "screen" => "<SCREEN_ID>"
          },
          "flow_cta" => "Open Flow!",
          "flow_id" => "{{Flow-ID}}",
          "flow_message_version" => "3",
          "flow_token" => "<FLOW_TOKEN>"
        }
      },
      "body" => %{"text" => "<BODY_TEXT>"},
      "footer" => %{"text" => "<FOOTER_TEXT>"},
      "header" => %{"text" => "<HEADER_TEXT>", "type" => "text"},
      "type" => "flow"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Order Status Message

      %{
    "interactive" => %{
      "action" => %{
        "name" => "review_order",
        "parameters" => %{
          "order" => %{"description" => "optional-text", "status" => "processing"},
          "reference_id" => "unique-reference-id-from-order-details-msg"
        }
      },
      "body" => %{"text" => "your-text-body-content"},
      "type" => "order_status"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-WA-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Reply to Location Message

      %{
    "context" => %{"message_id" => "<MSGID_OF_PREV_MSG>"},
    "location" => %{
      "address" => "1 Hacker Way, Menlo Park, CA 94025",
      "latitude" => 37.758056,
      "longitude" => -122.425332,
      "name" => "META HQ"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "location"
  }

  ### Send Single Product Message

      %{
    "interactive" => %{
      "action" => %{
        "catalog_id" => "367025965434465",
        "product_retailer_id" => "<ID_TEST_ITEM_1>"
      },
      "body" => %{"text" => "<OPTIONAL_BODY_TEXT>"},
      "footer" => %{"text" => "<OPTIONAL_FOOTER_TEXT>"},
      "type" => "product"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Message Template Text

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "template" => %{
      "components" => [
        %{
          "parameters" => [
            %{"text" => "text-string", "type" => "text"},
            %{
              "currency" => %{
                "amount_1000" => 100990,
                "code" => "USD",
                "fallback_value" => "$100.99"
              },
              "type" => "currency"
            },
            %{
              "date_time" => %{
                "calendar" => "GREGORIAN",
                "day_of_month" => 25,
                "day_of_week" => 5,
                "fallback_value" => "February 25, 1977",
                "hour" => 15,
                "minute" => 33,
                "month" => 2,
                "year" => 1977
              },
              "type" => "date_time"
            }
          ],
          "type" => "body"
        }
      ],
      "language" => %{"code" => "language-and-locale-code"},
      "name" => "template-name"
    },
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "template"
  }

  ### Send Video Message by URL

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "video",
    "video" => %{
      "caption" => "<VIDEO_CAPTION_TEXT>",
      "link" => "<http(s)://video-url>"
    }
  }

  ### Send Audio Message by ID

      %{
    "audio" => %{"id" => "<AUDIO_OBJECT_ID>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "audio"
  }

  ### Send Reply to Contact Message

      %{
    "contacts" => [
      %{
        "addresses" => [
          %{
            "city" => "Menlo Park",
            "country" => "United States",
            "country_code" => "us",
            "state" => "CA",
            "street" => "1 Hacker Way",
            "type" => "HOME",
            "zip" => "94025"
          },
          %{
            "city" => "Menlo Park",
            "country" => "United States",
            "country_code" => "us",
            "state" => "CA",
            "street" => "200 Jefferson Dr",
            "type" => "WORK",
            "zip" => "94025"
          }
        ],
        "birthday" => "2012-08-18",
        "emails" => [
          %{"email" => "test@fb.com", "type" => "WORK"},
          %{"email" => "test@whatsapp.com", "type" => "HOME"}
        ],
        "name" => %{
          "first_name" => "John",
          "formatted_name" => "John Smith",
          "last_name" => "Smith",
          "middle_name" => "D.",
          "prefix" => "Dr",
          "suffix" => "Jr"
        },
        "org" => %{
          "company" => "WhatsApp",
          "department" => "Design",
          "title" => "Manager"
        },
        "phones" => [
          %{"phone" => "+1 (940) 555-1234", "type" => "HOME"},
          %{
            "phone" => "+1 (650) 555-1234",
            "type" => "WORK",
            "wa_id" => "16505551234"
          }
        ],
        "urls" => [
          %{"type" => "WORK", "url" => "https://www.facebook.com"},
          %{"type" => "HOME", "url" => "https://www.whatsapp.com"}
        ]
      }
    ],
    "context" => %{"message_id" => "<MSGID_OF_PREV_MSG>"},
    "messaging_product" => "whatsapp",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "contacts"
  }

  ### Send Document Message by ID

      %{
    "document" => %{
      "caption" => "<DOCUMENT_CAPTION_TO_SEND>",
      "filename" => "<DOCUMENT_FILENAME>",
      "id" => "<DOCUMENT_OBJECT_ID>"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "document"
  }

  ### Send Reply to Sticker Message by ID

      %{
    "context" => %{"message_id" => "<MSGID_OF_MSG_YOU_ARE_REPLYING_TO>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "sticker" => %{"id" => "<MEDIA_OBJECT_ID>"},
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "sticker"
  }

  ### Send Reply to Image Message by URL

      %{
    "context" => %{"message_id" => "<MSGID_OF_PREV_MSG>"},
    "image" => %{"link" => "http(s)://image-url"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "image"
  }

  ### Send Reply to Document Message by URL

      %{
    "context" => %{"message_id" => "<MSGID_OF_MSG_YOU_ARE_REPLYING_TO>"},
    "document" => %{
      "caption" => "<DOCUMENT_CAPTION_TEXT>",
      "link" => "<http(s)://document-url>"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "document"
  }

  ### Send Reply to Document Message by ID

      %{
    "context" => %{"message_id" => "<MSGID_OF_MSG_YOU_ARE_REPLYING_TO>"},
    "document" => %{
      "caption" => "<DOCUMENT_CAPTION_TO_SEND>",
      "filename" => "<DOCUMENT_FILENAME>",
      "id" => "<DOCUMENT_OBJECT_ID>"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "document"
  }

  ### Send Sample Shipping Confirmation Template

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "template" => %{
      "components" => [
        %{
          "parameters" => [
            %{"text" => "text-string", "type" => "text"},
            %{
              "currency" => %{
                "amount_1000" => 100990,
                "code" => "USD",
                "fallback_value" => "$100.99"
              },
              "type" => "currency"
            },
            %{
              "date_time" => %{
                "calendar" => "GREGORIAN",
                "day_of_month" => 25,
                "day_of_week" => 5,
                "fallback_value" => "February 25, 1977",
                "hour" => 15,
                "minute" => 33,
                "month" => 2,
                "year" => 1977
              },
              "type" => "date_time"
            }
          ],
          "type" => "body"
        }
      ],
      "language" => %{"code" => "language-and-locale-code"},
      "name" => "template-name"
    },
    "to" => "16315555555",
    "type" => "template"
  }

  ### Send typing indicator and read receipt

      %{
    "message_id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQUYzMjEzNDM2RTZGQ0MzMDJBRgA=",
    "messaging_product" => "whatsapp",
    "status" => "read",
    "typing_indicator" => %{"type" => "text"}
  }

  ### Send Draft Flow by Name

      %{
    "interactive" => %{
      "action" => %{
        "name" => "flow",
        "parameters" => %{
          "flow_action" => "navigate",
          "flow_action_payload" => %{
            "data" => %{"<CUSTOM_KEY>" => "<CUSTOM_VALUE>"},
            "screen" => "<SCREEN_ID>"
          },
          "flow_cta" => "Not shown in draft mode",
          "flow_message_version" => "3",
          "flow_name" => "{{Flow-Name}}",
          "flow_token" => "<FLOW_TOKEN>",
          "mode" => "draft"
        }
      },
      "body" => %{"text" => "Not shown in draft mode"},
      "footer" => %{"text" => "Not shown in draft mode"},
      "header" => %{"text" => "Not shown in draft mode", "type" => "text"},
      "type" => "flow"
    },
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "interactive"
  }

  ### Send Message Template Media

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "template" => %{
      "components" => [
        %{
          "parameters" => [
            %{
              "image" => %{"link" => "http(s)://the-image-url"},
              "type" => "image"
            }
          ],
          "type" => "header"
        },
        %{
          "parameters" => [
            %{"text" => "text-string", "type" => "text"},
            %{
              "currency" => %{
                "amount_1000" => 100990,
                "code" => "USD",
                "fallback_value" => "$100.99"
              },
              "type" => "currency"
            },
            %{
              "date_time" => %{
                "calendar" => "GREGORIAN",
                "day_of_month" => 25,
                "day_of_week" => 5,
                "fallback_value" => "February 25, 1977",
                "hour" => 15,
                "minute" => 33,
                "month" => 2,
                "year" => 1977
              },
              "type" => "date_time"
            }
          ],
          "type" => "body"
        }
      ],
      "language" => %{"code" => "language-and-locale-code"},
      "name" => "template-name"
    },
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "template"
  }

  ### Send Sample Issue Resolution Template

      %{
    "messaging_product" => "whatsapp",
    "template" => %{
      "components" => [
        %{
          "parameters" => [%{"text" => "*Mr. Jones*", "type" => "text"}],
          "type" => "body"
        },
        %{
          "index" => 0,
          "parameters" => [%{"text" => true, "type" => "text"}],
          "sub_type" => "quick_reply",
          "type" => "button"
        },
        %{
          "index" => 1,
          "parameters" => [%{"text" => false, "type" => "text"}],
          "sub_type" => "quick_reply",
          "type" => "button"
        }
      ],
      "language" => %{"code" => "en_US", "policy" => "deterministic"},
      "name" => "sample_issue_resolution"
    },
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "template"
  }

  ### Send Reply to Video Message by URL

      %{
    "context" => %{"message_id" => "<MSGID_OF_MSG_YOU_ARE_REPLYING_TO>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "video",
    "video" => %{
      "caption" => "<VIDEO_CAPTION_TEXT>",
      "link" => "<http(s)://video-url>"
    }
  }

  ### Send Message Template Interactive

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "template" => %{
      "components" => [
        %{
          "parameters" => [
            %{
              "image" => %{"link" => "http(s)://the-image-url"},
              "type" => "image"
            }
          ],
          "type" => "header"
        },
        %{
          "parameters" => [
            %{"text" => "text-string", "type" => "text"},
            %{
              "currency" => %{
                "amount_1000" => 100990,
                "code" => "USD",
                "fallback_value" => "$100.99"
              },
              "type" => "currency"
            },
            %{
              "date_time" => %{
                "calendar" => "GREGORIAN",
                "day_of_month" => 25,
                "day_of_week" => 5,
                "fallback_value" => "February 25, 1977",
                "hour" => 15,
                "minute" => 33,
                "month" => 2,
                "year" => 1977
              },
              "type" => "date_time"
            }
          ],
          "type" => "body"
        },
        %{
          "index" => "0",
          "parameters" => [
            %{"payload" => "aGlzIHRoaXMgaXMgY29v", "type" => "payload"}
          ],
          "sub_type" => "quick_reply",
          "type" => "button"
        },
        %{
          "index" => "1",
          "parameters" => [
            %{"payload" => "9rwnB8RbYmPF5t2Mn09x4h", "type" => "payload"}
          ],
          "sub_type" => "quick_reply",
          "type" => "button"
        }
      ],
      "language" => %{"code" => "language-and-locale-code"},
      "name" => "template-name"
    },
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "template"
  }

  ### Send Sticker Message by URL

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "sticker" => %{"link" => "<http(s)://sticker-url>"},
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "sticker"
  }

  ### Send Sticker Message by ID

      %{
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "sticker" => %{"id" => "<MEDIA_OBJECT_ID>"},
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "sticker"
  }

  ### Send Contact Message

      %{
    "contacts" => [
      %{
        "addresses" => [
          %{
            "city" => "Menlo Park",
            "country" => "United States",
            "country_code" => "us",
            "state" => "CA",
            "street" => "1 Hacker Way",
            "type" => "HOME",
            "zip" => "94025"
          },
          %{
            "city" => "Menlo Park",
            "country" => "United States",
            "country_code" => "us",
            "state" => "CA",
            "street" => "200 Jefferson Dr",
            "type" => "WORK",
            "zip" => "94025"
          }
        ],
        "birthday" => "2012-08-18",
        "emails" => [
          %{"email" => "test@fb.com", "type" => "WORK"},
          %{"email" => "test@whatsapp.com", "type" => "HOME"}
        ],
        "name" => %{
          "first_name" => "John",
          "formatted_name" => "John Smith",
          "last_name" => "Smith",
          "middle_name" => "D.",
          "prefix" => "Dr",
          "suffix" => "Jr"
        },
        "org" => %{
          "company" => "WhatsApp",
          "department" => "Design",
          "title" => "Manager"
        },
        "phones" => [
          %{"phone" => "+1 (940) 555-1234", "type" => "HOME"},
          %{
            "phone" => "+1 (650) 555-1234",
            "type" => "WORK",
            "wa_id" => "16505551234"
          }
        ],
        "urls" => [
          %{"type" => "WORK", "url" => "https://www.facebook.com"},
          %{"type" => "HOME", "url" => "https://www.whatsapp.com"}
        ]
      }
    ],
    "messaging_product" => "whatsapp",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "contacts"
  }

  ### Send Reply to Video Message by ID

      %{
    "context" => %{"message_id" => "<MSGID_OF_MSG_YOU_ARE_REPLYING_TO>"},
    "messaging_product" => "whatsapp",
    "recipient_type" => "individual",
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "video",
    "video" => %{"caption" => "<VIDEO_CAPTION_TEXT>", "id" => "<VIDEO_OBJECT_ID>"}
  }

  ### Send Test Message

      %{
    "messaging_product" => "whatsapp",
    "template" => %{"language" => %{"code" => "en_US"}, "name" => "hello_world"},
    "to" => "{{Recipient-Phone-Number}}",
    "type" => "template"
  }
  """
  @spec send_message(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, WhatsApp.Resources.MessageResponsePayload.t()}
          | {:ok, WhatsApp.Resources.MessageResponsePayload.t(), WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def send_message(client, params, opts \\ []) do
    phone_number_id = Keyword.get(opts, :phone_number_id, client.phone_number_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{phone_number_id}/messages",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.MessageResponsePayload)}

      {:ok, data, resp} ->
        {:ok, WhatsApp.Deserializer.deserialize(data, WhatsApp.Resources.MessageResponsePayload),
         resp}

      error ->
        error
    end
  end
end
