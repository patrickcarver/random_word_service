defmodule RandomWordService.MixProject do
  use Mix.Project

  def project do
    [
      app: :random_word_service,
      version: "1.0.2",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: { RandomWordService.Application, [] },
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :validatorex, git: "https://github.com/patrickcarver/validatorex.git", tag: "v0.2.0" }
    ]
  end
end
