defmodule DhcpWatcher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    MetricsPlugExporter.setup()

    children = [
      # Starts a worker by calling: DhcpWatcher.Worker.start_link(arg)
      {DhcpWatcher.Worker, dirs: [Application.fetch_env!(:dhcp_watcher, :dhcp_file)]},
      {Plug.Cowboy, scheme: :http, plug: DhcpWatcher.MetricsServer, options: [port: 4001]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DhcpWatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
