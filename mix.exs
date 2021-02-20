defmodule Burp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :burp,
      version: "0.3.2",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Burp.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:plug_cowboy, "~> 2.1"},
      {:ecto_sql, "~> 3.4"},
      {:phoenix_ecto, "~> 4.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:comeonin, "~> 3.0"},
      {:timex, "~> 3.1"},
      {:cmark, "~> 0.7"},
      {:xml_builder, "~> 2.1.1"},
      {:swoosh, "~> 1.3"},
      {:gen_smtp, "~> 1.1"},
      {:phoenix_swoosh, "~> 0.3"},
      {:ex_machina, "~> 2.1", only: :test},
      {:jason, "~> 1.0"},
      {:appsignal_phoenix, "~> 2.0.0"},
      {:gh_webhook_plug, "~> 0.0.5"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      build: "cmd ./.build/build",
      deploy: "cmd ./.build/deploy"
    ]
  end
end
