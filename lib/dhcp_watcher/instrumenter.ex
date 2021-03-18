defmodule DhcpWatcher.Instrumenter do
  alias DhcpWatcher.Lease
  use Prometheus.Metric

  def setup do
    Gauge.new([
      name: :router_dhcp_table,
      labels: [:hostname, :ip_address, :mac_address, :is_active],
      help: "DHCP assignment info"
    ])
  end

  def publish_lease(lease = %Lease{}) do
    Gauge.set([
      name: :router_dhcp_table,
      labels: [
        lease.hostname,
        lease.ip_address,
        lease.mac_address,
        lease.is_active
      ]
    ], Timex.to_unix(lease.lease_end))
  end
end
