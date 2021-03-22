defmodule DhcpWatcher.Application do
  require Logger
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    MetricsPlugExporter.setup()

    children = [
      # Starts a worker by calling: DhcpWatcher.Worker.start_link(arg)
      {Plug.Cowboy, scheme: :http, plug: DhcpWatcher.Router, options: [port: 4001]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Logger.info("starting server")
    opts = [strategy: :one_for_one, name: DhcpWatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
