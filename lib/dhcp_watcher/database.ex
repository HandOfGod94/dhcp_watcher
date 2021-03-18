defmodule DhcpWatcher.Database do
  alias DhcpWatcher.Lease
  require Logger

  def get_all_lease(content) do
    Logger.info("starting parsing dhcp database file")

    lease_list =
      content
      |> String.trim()
      |> String.split("}")
      |> Stream.filter(&(&1 != ""))
      |> Enum.map(&Lease.parse/1)

    Logger.info("database file parsing complete")
    lease_list
  end
end
