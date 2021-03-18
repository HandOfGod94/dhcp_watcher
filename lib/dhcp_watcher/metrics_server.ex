defmodule MetricsPlugExporter do
  use Prometheus.PlugExporter
end

defmodule DhcpWatcher.MetricsServer do
  use Plug.Router

  plug(MetricsPlugExporter)
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
