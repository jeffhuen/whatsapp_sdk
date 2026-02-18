defmodule WhatsApp.MixProject do
  use Mix.Project

  @source_url "https://github.com/jeffhuen/whatsapp_sdk"
  @version "0.1.0"

  def project do
    [
      app: :whatsapp_sdk,
      version: @version,
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [
        threshold: 50,
        ignore_modules: [
          ~r/^WhatsApp\.Messages\./,
          ~r/^WhatsApp\.Media\./,
          ~r/^WhatsApp\.Templates\./,
          ~r/^WhatsApp\.PhoneNumbers\./,
          ~r/^WhatsApp\.BusinessProfiles\./,
          ~r/^WhatsApp\.Flows\./,
          ~r/^WhatsApp\.QrCodes\./,
          ~r/^WhatsApp\.Calls\./,
          ~r/^WhatsApp\.BusinessManagement\./,
          ~r/^WhatsApp\.Resources\./,
          ~r/^WhatsApp\.Generator\./
        ]
      ],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        plt_add_apps: [:mix],
        flags: [:unmatched_returns, :error_handling, :extra_return, :missing_return]
      ],
      compilers: Mix.compilers()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {WhatsApp.Application, []}
    ]
  end

  def cli do
    [preferred_envs: [coveralls: :test, "coveralls.html": :test]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # HTTP (direct Finch for minimal overhead, connection pooling, HTTP/2)
      {:finch, "~> 0.19"},

      # Telemetry (standard observability)
      {:telemetry, "~> 1.0"},

      # OpenAPI parsing (codegen only — NOT a runtime dep)
      {:rustyjson, "~> 0.3", only: :dev, runtime: false},

      # Webhook / Phoenix integration (optional)
      {:plug, "~> 1.16", optional: true},

      # Dev/Test
      {:nimble_ownership, "~> 1.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: "whatsapp_sdk",
      description:
        "Comprehensive Elixir SDK for the WhatsApp Business Platform Cloud API with full endpoint coverage. 79 service modules, 352 typed resource structs, and 113 operations generated from Meta's official OpenAPI spec.",
      maintainers: ["Jeff Huen"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE CHANGELOG.md OPENAPI_VERSION),
      exclude_patterns: ~w(lib/mix lib/whatsapp/generator)
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: [
        "README.md",
        "CHANGELOG.md",
        "LICENSE",
        "guides/getting-started.md",
        "guides/webhooks.md",
        "guides/interactive-messages.md",
        "guides/testing.md"
      ],
      groups_for_modules: [
        Core: [WhatsApp, WhatsApp.Client, WhatsApp.Config],
        "Error Handling": [WhatsApp.Error],
        Pagination: [WhatsApp.Page],
        Webhooks: [WhatsApp.Webhook],
        "Interactive Messages": [WhatsApp.Interactive],
        Messages: ~r/WhatsApp\.Messages\./,
        Media: ~r/WhatsApp\.Media\./,
        Templates: ~r/WhatsApp\.Templates\./,
        "Phone Numbers": ~r/WhatsApp\.PhoneNumbers\./,
        "Business Profiles": ~r/WhatsApp\.BusinessProfiles\./,
        Flows: ~r/WhatsApp\.Flows\./,
        "QR Codes": ~r/WhatsApp\.QrCodes\./,
        Calls: ~r/WhatsApp\.Calls\./,
        "Business Management": ~r/WhatsApp\.BusinessManagement\./,
        Resources: ~r/WhatsApp\.Resources\./
      ]
    ]
  end
end
