defmodule ComeBike.Mixfile do
  use Mix.Project

  def project do
    [
      app: :come_bike,
      version: "0.0.2",
      elixir: "~> 1.6.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ComeBike.Application, []},
      extra_applications: [:logger, :runtime_tools, :ueberauth]
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
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:excoveralls, "~> 0.8.0", only: :test},
      {:phauxth, "~> 1.2"},
      {:argon2_elixir, "~> 1.2"},
      {:ueberauth, github: "ueberauth/ueberauth", override: true},
      {:ueberauth_facebook, "~> 0.7.0"},
      {:edeliver, "~> 1.4.4"},
      {:distillery, ">= 0.8.0", warn_missing: false},
      {:sentry, "~> 6.0.0"},
      {:ex_machina, "~> 2.1", only: :test},
      {:tesla, "~> 0.10.0"},
      {:poison, ">= 1.0.0"},
      {:timex, "~> 3.1"},
      {:timex_ecto, "~> 3.2"},
      {:geo, "~> 2.0"},
      {:geo_postgis, "~> 1.0"}
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
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
