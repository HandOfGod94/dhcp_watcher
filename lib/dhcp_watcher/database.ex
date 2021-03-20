defmodule DhcpWatcher.Database do
  alias DhcpWatcher.Lease
  require Logger

  def get_all_lease(content) do
    Logger.info("starting parsing dhcp database file")

    lease_list =
      String.trim(content)
      |> String.split("}")
      |> Stream.filter(&blank_string?/1)
      |> Enum.map(&Lease.parse/1)

    Logger.info("database file parsing complete")
    lease_list
  end

  defp blank_string?(str), do: str == ""
end
