defmodule CoreIdentityElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :core_identity_elixir,
      version: "0.1.1",
      elixir: "~> 1.14.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "CoreIdentityElixir",
      source_url: "https://github.com/SullysMustyRuby/core_identity_elixir",
      homepage_url: "https://core-apis.com//",
      docs: [main: "CoreIdentityElixir.CoreIdentity", extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.29.1", only: [:dev]},
      {:gettext, "~> 0.20.0"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.4"},
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.2"}
    ]
  end

  defp description do
    "An elixir client library for CoreIdentity"
  end

  defp package do
    [
      maintainers: ["Erin Boeger"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/SullysMustyRuby/core_identity_elixir"}
    ]
  end
end
