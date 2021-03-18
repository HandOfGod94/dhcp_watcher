defmodule DhcpWatcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :dhcp_watcher,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      xref: [exclude: [:mnesia]],
      releases: [
        dhcp_watcher: [
          include_executables_for: [:unix],
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DhcpWatcher.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:file_system, "~> 0.2"},
      {:plug_cowboy, "~> 2.0"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1"},
    ]
  end
end
