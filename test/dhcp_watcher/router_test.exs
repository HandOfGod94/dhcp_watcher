defmodule DhcpWatcher.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias DhcpWatcher.Router

  describe "GET /leases" do
    test "expose assigned lease as json" do
      conn = conn(:get, "/lease") |> Router.call([])
      assert conn.status == 200

      assert Jason.decode!(conn.resp_body) == [
               %{
                 "hostname" => "Chromecast",
                 "ip_address" => "192.168.0.1",
                 "is_active" => true,
                 "lease_end" => "2025-03-20T12:32:55",
                 "mac_address" => "12:23:45:56:78:90"
               }
             ]
    end
  end

  describe "GET /health" do
    test "returns success response" do
      conn = conn(:get, "/health") |> Router.call([])
      assert conn.status == 200
      assert Jason.decode!(conn.resp_body) == %{"success" => true}
    end
  end
end
