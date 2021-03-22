defmodule DhcpWatcher do
  require Logger
  alias __MODULE__.Lease

  def get_future_lease(content) do
    content
    |> get_all_lease()
    |> Enum.filter(&(&1.is_active == true))
    |> Enum.filter(&(NaiveDateTime.compare(&1.lease_end, NaiveDateTime.utc_now()) == :gt))
  end

  def get_all_lease(content) do
    Logger.info("starting parsing dhcp database file")

    lease_list =
      String.trim(content)
      |> String.split("}")
      |> Stream.reject(&blank_string?/1)
      |> Enum.map(&Lease.parse/1)

    Logger.info("database file parsing complete")
    lease_list
  end

  defp blank_string?(str), do: str == ""
end
