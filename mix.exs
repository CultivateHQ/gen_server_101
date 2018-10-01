defmodule GenServer101.MixProject do
  use Mix.Project

  def project do
    [
      app: :gen_server_101,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~>  0.5.1", only: [:dev, :prod]},
      {:credo, "~> 0.10.2", only: [:dev, :prod]}
    ]
  end
end
