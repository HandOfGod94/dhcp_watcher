defmodule MetricsPlugExporter do
  @moduledoc false
  use Prometheus.PlugExporter
end

defmodule DhcpWatcher.Router do
  use Plug.Router

  plug(MetricsPlugExporter)
  plug(:match)
  plug(:dispatch)
  plug(Plug.Parsers, parsers: [:urlencoded, {:json, json_decoder: Jason}])

  @path Application.compile_env!(:dhcp_watcher, :dhcp_file)

  get "/lease" do
    leases =
      @path
      |> File.read!()
      |> DhcpWatcher.get_future_lease()

    send_resp(conn, 200, Jason.encode!(leases))
  end

  get "/health" do
    send_resp(conn, 200, Jason.encode!(%{"success" => true}))
  end

  match _ do
    send_resp(conn, 404, Jason.encode!(%{"error" => "not found"}))
  end
end
