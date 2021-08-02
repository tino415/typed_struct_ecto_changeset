defmodule TypedStructEctoChangeset.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :typed_struct_ecto_changeset,
      version: "0.2.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: [
        extras: ["README.md"]
      ]
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

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ecto, "~> 3.4.6", only: [:test]},
      {:ex_doc, "~> 0.22", only: [:dev], runtime: false},
      {:typed_struct, "~> 0.2.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
