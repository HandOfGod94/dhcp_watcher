defmodule DhcpWatcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :dhcp_watcher,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      xref: [exclude: [:mnesia]],
      releases: [
        dhcp_watcher: [
          include_executables_for: [:unix],
          steps: [:assemble, :tar]
        ]
      ],
      dialyzer: [
        plt_add_deps: :transitive,
        flags: [:error_handling, :race_conditions],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
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
      {:plug_cowboy, "~> 2.0"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1"},
      {:jason, "~> 1.2"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      create_systemd_service: &create_systemd_service/1
    ]
  end

  defp create_systemd_service(_) do
    content =
      "./priv/"
      |> Path.join("systemd.sevice.eex")
      |> EEx.eval_file(app_name: "dhcp_watcher")

    file = File.open!("dhcp_watcher.service", [:write])
    IO.write(file, content)
    File.close(file)
  end
end
