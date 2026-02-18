defmodule WhatsApp.Flows.MessageTemplatesService do
  @moduledoc false

  @doc """
  Create authentication template w/ OTP copy code button

  - Guide: [Authentication Templates with OTP Buttons](https://developers.facebook.com/docs/business-messaging/whatsapp/templates/authentication-templates/authentication-templates)
  - Guide: [Message Templates](https://developers.facebook.com/docs/business-messaging/whatsapp/templates/overview)
  - Guide: [How To Monitor Quality Signals](https://developers.facebook.com/docs/whatsapp/guides/how-to-monitor-quality-signals)
  - Endpoint reference: [WhatsApp Business Account > Message Templates](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-account/message_templates/)

  ## Examples

  ### Create Flow Template Message by Flow JSON

      %{
    "category" => "MARKETING",
    "components" => [
      %{"text" => "Check out this new offer", "type" => "body"},
      %{
        "buttons" => [
          %{
            "flow_action" => "navigate",
            "flow_json" => "{\"version\":\"5.0\",\"screens\":[{\"id\":\"WELCOME_SCREEN\",\"layout\":{\"type\":\"SingleColumnLayout\",\"children\":[{\"type\":\"TextHeading\",\"text\":\"Hello World\"},{\"type\":\"Footer\",\"label\":\"Complete\",\"on-click-action\":{\"name\":\"complete\",\"payload\":{}}}]},\"title\":\"Welcome\",\"terminal\":true,\"success\":true,\"data\":{}}]}",
            "navigate_screen" => "WELCOME_SCREEN",
            "text" => "Check out this offer!",
            "type" => "FLOW"
          }
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "<TEMPLATE_NAME>"
  }

  ### Create Flow Template Message by ID

      %{
    "category" => "MARKETING",
    "components" => [
      %{"text" => "Check out this new offer", "type" => "body"},
      %{
        "buttons" => [
          %{
            "flow_action" => "navigate",
            "flow_id" => "{{Flow-ID}}",
            "navigate_screen" => "<SCREEN_ID>",
            "text" => "Check out this offer!",
            "type" => "FLOW"
          }
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "<TEMPLATE_NAME>"
  }

  ### Create Flow Template Message by Name

      %{
    "category" => "MARKETING",
    "components" => [
      %{"text" => "Check out this new offer", "type" => "body"},
      %{
        "buttons" => [
          %{
            "flow_action" => "navigate",
            "flow_name" => "{{Flow-Name}}",
            "navigate_screen" => "<SCREEN_ID>",
            "text" => "Check out this offer!",
            "type" => "FLOW"
          }
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "<TEMPLATE_NAME>"
  }

  ### Create authentication template w/ OTP copy code button

      %{
    "category" => "AUTHENTICATION",
    "components" => [
      %{"add_security_recommendation" => true, "type" => "BODY"},
      %{"code_expiration_minutes" => 10, "type" => "FOOTER"},
      %{
        "buttons" => [
          %{"otp_type" => "COPY_CODE", "text" => "Copy Code", "type" => "OTP"}
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "authentication_code_copy_code_button"
  }

  ### Create authentication template w/ OTP one-tap autofill button

      %{
    "category" => "AUTHENTICATION",
    "components" => [
      %{"add_security_recommendation" => true, "type" => "BODY"},
      %{"code_expiration_minutes" => 10, "type" => "FOOTER"},
      %{
        "buttons" => [
          %{
            "autofill_text" => "Autofill",
            "otp_type" => "ONE_TAP",
            "package_name" => "com.example.luckyshrub",
            "signature_hash" => "K8a%2FAINcGX7",
            "text" => "Copy Code",
            "type" => "OTP"
          }
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "authentication_code_autofill_button"
  }

  ### Create catalog template

      %{
    "category" => "AUTHENTICATION",
    "components" => [
      %{"add_security_recommendation" => true, "type" => "BODY"},
      %{"code_expiration_minutes" => 10, "type" => "FOOTER"},
      %{
        "buttons" => [
          %{
            "autofill_text" => "Autofill",
            "otp_type" => "ONE_TAP",
            "package_name" => "com.example.luckyshrub",
            "signature_hash" => "K8a%2FAINcGX7",
            "text" => "Copy Code",
            "type" => "OTP"
          }
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "authentication_code_autofill_button"
  }

  ### Create multi-product message template

      %{
    "category" => "MARKETING",
    "components" => [
      %{
        "example" => %{"header_text" => ["Pablo"]},
        "format" => "TEXT",
        "text" => "Forget something {{1}}?",
        "type" => "HEADER"
      },
      %{
        "example" => %{"body_text" => [["10OFF"]]},
        "text" => "Looks like you left some items in your cart! Use code {{1}} and you can get 10% off of all of them!",
        "type" => "BODY"
      },
      %{
        "buttons" => [%{"text" => "View items", "type" => "MPM"}],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "abandoned_cart"
  }

  ### Create template w/ document header, text body, a phone number button, and a URL button

      %{
    "category" => "UTILITY",
    "components" => [
      %{
        "example" => %{
          "header_handle" => ["4::YXBwbGljYXRpb24vcGRm:ARZVv4zuogJMxmAdS3_6T4o_K4ll2806avA7rWpikisTzYPsXXUeKk0REjS-hIM1rYrizHD7rQXj951TKgUFblgd_BDWVROCwRkg9Vhjj-cHNQ:e:1681237341:634974688087057:100089620928913:ARa1ZDhwbLZM3EENeeg"]
        },
        "format" => "DOCUMENT",
        "type" => "HEADER"
      },
      %{
        "example" => %{"body_text" => [["Mark", "860198-230332"]]},
        "text" => "Thank you for your order, {{1}}! Your order number is {{2}}. Tap the PDF linked above to view your receipt. If you have any questions, please use the buttons below to contact support. Thanks again!",
        "type" => "BODY"
      },
      %{
        "buttons" => [
          %{
            "phone_number" => "16467043595",
            "text" => "Call",
            "type" => "PHONE_NUMBER"
          },
          %{
            "text" => "Contact Support",
            "type" => "URL",
            "url" => "https://www.examplesite.com/support"
          }
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "order_confirmation"
  }

  ### Create template w/ image header, text body, text footer, and 2 call-to-action buttons

      %{
    "category" => "MARKETING",
    "components" => [
      %{
        "example" => %{
          "header_handle" => ["4::aW1hZ2UvanBn:ARYytyb0kLp5htbBB8vWlclG5M9gMBxiEyt4FNCvrueWBOmFmRAztEuNtPGUnEC22Etc_SAAVU0YJOk3B7A-JuR1241_nq7gfITFxXKdDGnfvw:e:1681000441:634974688087057:100089620928913:ARbB4l0IPRncfMF-1sE\n4::aW1hZ2UvanBn:ARZewDmbZuoq3rGUO1WgXjJEYcI1Tt7jr_Z6o2-oD5rg4--AQarBV_S1BYEcR8INJkctK0lNJmQ5v7PsBo-vqB-N0DSTe2-G6jHOlxKc12KSSg:e:1681000441:634974688087057:100089620928913:ARZQmT7tfO0sW--3oLo\n4::aW1hZ2UvanBn:ARZkcJXFoEMa0YMMd2WQT8aVMJFaUPlSYW9xXshyh1bP-Pd6JP4t2VbrZezqGOEfC-acYkRZA5Q31FX7dEE_hQ9a-0i-b-RaueQrWO6vWk-7bQ:e:1681000441:634974688087057:100089620928913:ARYlgv7ErOQGsZYClfs"]
        },
        "format" => "IMAGE",
        "type" => "HEADER"
      },
      %{
        "example" => %{"body_text" => [["Mark", "Tuscan Getaway package", "800"]]},
        "text" => "Hi {{1}}! For a limited time only you can get our {{2}} for as low as {{3}}. Tap the Offer Details button for more information.",
        "type" => "BODY"
      },
      %{"text" => "Offer valid until May 31, 2023", "type" => "FOOTER"},
      %{
        "buttons" => [
          %{
            "phone_number" => "16467043595",
            "text" => "Call",
            "type" => "PHONE_NUMBER"
          },
          %{
            "example" => ["summer2023"],
            "text" => "Shop Now",
            "type" => "URL",
            "url" => "https://damp-sea-63235.herokuapp.com/shop?promo={{1}}"
          }
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "limited_time_offer_tuscan_getaway_2023"
  }

  ### Create template w/ location header, text body, text footer, and a website buttons

      %{
    "category" => "UTILITY",
    "components" => [
      %{"format" => "LOCATION", "type" => "HEADER"},
      %{
        "example" => %{"body_text" => [["Mark", "566701"]]},
        "text" => "Good news {{1}}! Your order \#{{2}} is on its way to the location above. Thank you for your order!",
        "type" => "BODY"
      },
      %{
        "text" => "To stop receiving delivery updates, tap the button below.",
        "type" => "FOOTER"
      },
      %{
        "buttons" => [
          %{"text" => "Stop Delivery Updates", "type" => "QUICK_REPLY"}
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en_US",
    "name" => "order_delivery_update"
  }

  ### Create template w/ text header, text body, text footer, and 2 quick reply buttons

      %{
    "category" => "MARKETING",
    "components" => [
      %{
        "example" => %{"header_text" => ["Summer Sale"]},
        "format" => "TEXT",
        "text" => "Our {{1}} is on!",
        "type" => "HEADER"
      },
      %{
        "example" => %{"body_text" => [["the end of August", "25OFF", "25%"]]},
        "text" => "Shop now through {{1}} and use code {{2}} to get {{3}} off of all merchandise.",
        "type" => "BODY"
      },
      %{
        "text" => "Use the buttons below to manage your marketing subscriptions",
        "type" => "FOOTER"
      },
      %{
        "buttons" => [
          %{"text" => "Unsubcribe from Promos", "type" => "QUICK_REPLY"},
          %{"text" => "Unsubscribe from All", "type" => "QUICK_REPLY"}
        ],
        "type" => "BUTTONS"
      }
    ],
    "language" => "en",
    "name" => "seasonal_promotion_text_only"
  }
  """
  @spec create_authentication_template_w_otp_copy_code_button(
          WhatsApp.Client.t(),
          map(),
          keyword()
        ) ::
          {:ok, WhatsApp.Resources.CreateAuthenticationTemplateWOtpCopyCodeButton.t()}
          | {:ok, WhatsApp.Resources.CreateAuthenticationTemplateWOtpCopyCodeButton.t(),
             WhatsApp.Response.t()}
          | {:error, WhatsApp.Error.t()}
  def create_authentication_template_w_otp_copy_code_button(client, params, opts \\ []) do
    waba_id = Keyword.get(opts, :waba_id, client.waba_id)

    case WhatsApp.Client.request(
           client,
           :post,
           "/#{client.api_version}/#{waba_id}/message_templates",
           [json: params] ++ opts
         ) do
      {:ok, data} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.CreateAuthenticationTemplateWOtpCopyCodeButton
         )}

      {:ok, data, resp} ->
        {:ok,
         WhatsApp.Deserializer.deserialize(
           data,
           WhatsApp.Resources.CreateAuthenticationTemplateWOtpCopyCodeButton
         ), resp}

      error ->
        error
    end
  end
end
