defmodule WhatsApp.Webhooks.WebhooksService do
  @moduledoc false

  @doc """
  Receive incoming WhatsApp messages

  Endpoint for receiving webhook payloads for diverse incoming WhatsApp message types.

  ## Examples

  ### Button Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "button" => %{
                    "payload" => "Unsubscribe",
                    "text" => "Unsubscribe"
                  },
                  "context" => %{
                    "from" => "15550783881",
                    "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgARGBJFNjk2OTMwNEZCQjhGMzUyQUYA"
                  },
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQUU0M0MxQzQzMUJCMTMwNUZFOQA=",
                  "timestamp" => "1750091045",
                  "type" => "button"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Contact Sharing Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "contacts" => [
                    %{
                      "name" => %{
                        "first_name" => "Lucía",
                        "formatted_name" => "Lucía Gómez",
                        "last_name" => "Gómez"
                      },
                      "org" => %{"company" => "Google"},
                      "phones" => [
                        %{
                          "phone" => "+1 (983) 555-2319",
                          "type" => "MOBILE",
                          "wa_id" => "19835552319"
                        }
                      ]
                    }
                  ],
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQTRBNjU5OUFFRTAzODEwMTQ0RgA=",
                  "timestamp" => "1744344496",
                  "type" => "contacts"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Group Create Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "group_lifecycle_update",
            "value" => %{
              "groups" => [
                %{
                  "added_participants" => [
                    %{"input" => 16505551234, "wa_id" => 16505551234},
                    %{"input" => 16505551235, "wa_id" => 16505551235}
                  ],
                  "description" => "your-group-description",
                  "group_id" => "Y2FwaV9ncm91cDoxODA1NTU1MDE3MjoxMjAzNjMyMjI3NzE5NjMwNjcZD",
                  "request_id" => "784D93D0C468593037EA0B1ECA245D9C",
                  "subject" => "your-group-subject",
                  "timestamp" => "1750269342",
                  "type" => "group_create"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "102290129340398"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Group Remove Participants

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "group_participants_update",
            "value" => %{
              "groups" => [
                %{
                  "group_id" => "Y2FwaV9ncm91cDoxODA1NTU1MDE3MjoxMjAzNjMyMjI3NzE5NjMwNjcZD",
                  "removed_participants" => [
                    %{"input" => 16505551234, "wa_id" => 16505551234},
                    %{"input" => 16505551235, "wa_id" => 16505551235}
                  ],
                  "request_id" => "784D93D0C468593037EA0B1ECA245D9C",
                  "timestamp" => "1750269342",
                  "type" => "group_create"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "102290129340398"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Group Settings Update

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "group_settings_update",
            "value" => %{
              "groups" => [
                %{
                  "group_id" => "Y2FwaV9ncm91cDoxODA1NTU1MDE3MjoxMjAzNjMyMjI3NzE5NjMwNjcZD",
                  "profile_picture" => %{
                    "mime_type" => "image/jpeg",
                    "sha256" => "SfInY0gGKTsJlUWbwxC1k+FAD0FZHv"
                  },
                  "request_id" => "784D93D0C468593037EA0B1ECA245D9C",
                  "timestamp" => "1750269342",
                  "type" => "group_settings_update"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "102290129340398"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Image Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQTRBNjU5OUFFRTAzODEwMTQ0RgA=",
                  "image" => %{
                    "caption" => "Taj Mahal",
                    "id" => "1003383421387256",
                    "mime_type" => "image/jpeg",
                    "sha256" => "SfInY0gGKTsJlUWbwxC1k+FAD0FZHvzwfpvO0zX0GUI="
                  },
                  "timestamp" => "1744344496",
                  "type" => "image"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Interactive Button Reply Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "context" => %{
                    "from" => "15550783881",
                    "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgARGBI3MEM2RUJFNkI0RENGQTVDRjUA"
                  },
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQTZBQzg0MzQ4QjRCM0NGNkVGOAA=",
                  "interactive" => %{
                    "button_reply" => %{
                      "id" => "cancel-button",
                      "title" => "Cancel"
                    },
                    "type" => "button_reply"
                  },
                  "timestamp" => "1750025136",
                  "type" => "interactive"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Interactive List Reply Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "context" => %{
                    "from" => "15550783881",
                    "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgARGBJGMzEyNzhENTZDMzNGODlDRDgA"
                  },
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQUJDQ0NDM0FEODY4ODkzOTc5RgA=",
                  "interactive" => %{
                    "list_reply" => %{
                      "description" => "Next Day to 2 Days",
                      "id" => "priority_express",
                      "title" => "Priority Mail Express"
                    },
                    "type" => "list_reply"
                  },
                  "timestamp" => "1749854575",
                  "type" => "interactive"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Location Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQTU2MjZEMDBGRkE3MENEMDE0RQA=",
                  "location" => %{
                    "address" => "101 Forest Ave, Palo Alto, CA 94301",
                    "latitude" => 37.44221496582,
                    "longitude" => -122.16165924072,
                    "name" => "Philz Coffee",
                    "url" => "https://philzcoffee.com/"
                  },
                  "timestamp" => "1744344496",
                  "type" => "location"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Order Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQTEyQjFGNzI1QTQxMjI5QTMyOQA=",
                  "order" => %{
                    "catalog_id" => "194836987003835",
                    "product_items" => [
                      %{
                        "currency" => "USD",
                        "item_price" => 30,
                        "product_retailer_id" => "di9ozbzfi4",
                        "quantity" => 2
                      },
                      %{
                        "currency" => "USD",
                        "item_price" => 25,
                        "product_retailer_id" => "nqryix03ez",
                        "quantity" => 1
                      }
                    ],
                    "text" => ""
                  },
                  "timestamp" => "1750096325",
                  "type" => "order"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Reaction Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQTRBNjU5OUFFRTAzODEwMTQ0RgA=",
                  "reaction" => %{
                    "emoji" => "👍",
                    "message_id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgARGBI0RTJEOTc2ODVERUY5RDlGNkYA"
                  },
                  "timestamp" => "1749419544",
                  "type" => "reaction"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### System Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "messages" => [
                %{
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTk4MzU1NTE5NzQVAgASGAoxMTgyMDg2MjY3AA==",
                  "system" => %{
                    "body" => "User Sheena Nelson changed from 16505551234 to 12195555358",
                    "type" => "user_changed_number",
                    "wa_id" => "12195555358"
                  },
                  "timestamp" => "1750269342",
                  "type" => "system"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "102290129340398"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Text Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQTRBNjU5OUFFRTAzODEwMTQ0RgA=",
                  "text" => %{"body" => "Does it come in another color?"},
                  "timestamp" => "1749416383",
                  "type" => "text"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Text Message from Click to WhatsApp Ad

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQUQ0N0VFMDA2MTQ0RkJFNkNDNAA=",
                  "referral" => %{
                    "body" => "Summer Succulents are here!",
                    "ctwa_clid" => "Aff-n8ZTODiE79d22KtAwQKj9e_mIEOOj27vDVwFjN80dp4_0NiNhEgpGo0AHemvuSoifXaytfTzcchptiErTKCqTrJ5nW1h7IHYeYymGb5K5J5iTROpBhWAGaIAeUzHL50",
                    "headline" => "Chat with us",
                    "image_url" => "https://scontent.xx.fbcdn.net/v/t45.1...",
                    "media_type" => "image",
                    "source_id" => "120226305854810726",
                    "source_type" => "ad",
                    "source_url" => "https://fb.me/3cr4Wqqkv",
                    "welcome_message" => %{
                      "text" => "Hi there! Let us know how we can help!"
                    }
                  },
                  "text" => %{"body" => "Hello! Can I get more info on this?"},
                  "timestamp" => "1750275992",
                  "type" => "text"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "102290129340398"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Text Message with Context (Product Inquiry)

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "context" => %{
                    "from" => "15550783881",
                    "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgARGA9wcm9kdWN0X2lucXVpcnkA",
                    "referred_product" => %{
                      "catalog_id" => "194836987003835",
                      "product_retailer_id" => "di9ozbzfi4"
                    }
                  },
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTY1MDM4Nzk0MzkVAgASGBQzQTA2NTUwRkNEMDdFQjJCRUU0NQA=",
                  "text" => %{"body" => "Is this still available?"},
                  "timestamp" => "1750016800",
                  "type" => "text"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "102290129340398"
      }
    ],
    "object" => "whatsapp_business_account"
  }

  ### Unsupported Message

      %{
    "entry" => [
      %{
        "changes" => [
          %{
            "field" => "messages",
            "value" => %{
              "contacts" => [
                %{
                  "profile" => %{"name" => "Sheena Nelson"},
                  "wa_id" => "16505551234"
                }
              ],
              "messages" => [
                %{
                  "errors" => [
                    %{
                      "code" => 131051,
                      "error_data" => %{
                        "details" => "Message type is currently not supported."
                      },
                      "message" => "Message type unknown",
                      "title" => "Message type unknown"
                    }
                  ],
                  "from" => "16505551234",
                  "id" => "wamid.HBgLMTQyMDU1NTA3NDkVAgASGBI5N0MwRjg0RTVBNUI1RDA2OTkA",
                  "timestamp" => "1750090702",
                  "type" => "unsupported"
                }
              ],
              "messaging_product" => "whatsapp",
              "metadata" => %{
                "display_phone_number" => "15550783881",
                "phone_number_id" => "106540352242922"
              }
            }
          }
        ],
        "id" => "419561257915477"
      }
    ],
    "object" => "whatsapp_business_account"
  }
  """
  @spec post(WhatsApp.Client.t(), map(), keyword()) ::
          {:ok, map()} | {:ok, map(), WhatsApp.Response.t()} | {:error, WhatsApp.Error.t()}
  def post(client, params, opts \\ []) do
    WhatsApp.Client.request(client, :post, "/whatsapp/webhooks", [json: params] ++ opts)
  end
end
