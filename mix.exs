defmodule Hamlex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :hamlex,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      preferred_cli_env: [espec: :test],
      dialyzer: [
        flags: [:unknown, :underspecs, :unmatched_returns],
        ignore_warnings: "dialyzer.ignore-warnings",
      ],
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:combine, "~> 0.10.0"},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
      {:espec, "~> 1.4.6", only: :test},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false, github: "ignota/mix-test.watch", ref: "8ee5c331059e821830a325cd59e87821b3434f88"}, # TODO: waiting for https://github.com/lpil/mix-test.watch/pull/85
      {:poison, "~> 3.1", only: :test},
    ]
  end

  defp description() do
    "Haml template engine that doesn't depend on EEx."
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["Marnen Laibow-Koser"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/marnen/hamlex"}
    ]
  end
end
