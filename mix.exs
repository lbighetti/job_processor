defmodule JobProcessor.MixProject do
  use Mix.Project

  def project do
    [
      app: :job_processor,
      version: "1.0.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext, :phoenix_swagger] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  def application do
    [
      mod: {JobProcessor.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:excoveralls, "~> 0.10", only: :test},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.5", only: [:dev], runtime: false},
      {:libgraph, "~> 0.7"},
      {:phoenix_swagger, "~> 0.8"},
      {:ex_json_schema, "~> 0.5"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      test: ["test"]
    ]
  end
end
