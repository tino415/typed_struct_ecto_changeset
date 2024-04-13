defmodule TypedStructEctoChangeset.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :typed_struct_ecto_changeset,
      version: "1.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: [
        extras: ["README.md"]
      ],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Plugin for typed struct to integrate with changeset"
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/tino415/typed_struct_ecto_changeset"}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:ecto, "~> 3.10", only: [:test]},
      {:ex_doc, "~> 0.29", only: [:dev], runtime: false},
      {:typed_struct, "~> 0.3.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      "dev.checks": [
        "format",
        "compile --warnings-as-errors --all-warnings",
        "credo --strict",
        "dialyzer"
      ]
    ]
  end
end
