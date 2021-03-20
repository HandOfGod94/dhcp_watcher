defmodule MetricsPlugExporter do
  use Prometheus.PlugExporter
end

defmodule DhcpWatcher.Router do
  use Plug.Router
  alias DhcpWatcher.Database

  plug(MetricsPlugExporter)
  plug(:match)
  plug(:dispatch)
  plug(Plug.Parsers, parsers: [:urlencoded, {:json, json_decoder: Jason}])

  @path Application.fetch_env!(:dhcp_watcher, :dhcp_file)

  get "/lease" do
    leases =
      @path
      |> File.read!()
      |> Database.get_all_lease()
      |> Enum.filter(&(&1.is_active == true))

    send_resp(conn, 200, Jason.encode!(leases))
  end

  get "/health" do
    send_resp(conn, 200, Jason.encode!(%{"success" => true}))
  end

  match _ do
    send_resp(conn, 404, Jason.encode!(%{"error" => "not found"}))
  end
end
