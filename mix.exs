defmodule RandomWordService.MixProject do
  use Mix.Project

  def project do
    [
      app: :random_word_service,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:inflex, "~> 1.10.0"},
      {:verbs, "~> 0.5.4"}
    ]
  end
end
