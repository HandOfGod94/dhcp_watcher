defmodule DhcpWatcher do
  require Logger
  alias __MODULE__.Lease

  @typep lease_db :: binary()

  @spec get_future_lease(lease_db()) :: [Lease.t()]
  def get_future_lease(content) do
    content
    |> get_all_lease()
    |> Stream.filter(&(&1.is_active == true))
    |> Stream.filter(&(NaiveDateTime.compare(&1.lease_end, NaiveDateTime.utc_now()) == :gt))
    |> Enum.sort_by(& &1.lease_end, :desc)
    |> Enum.uniq_by(& &1.ip_address)
  end

  @spec get_all_lease(lease_db()) :: [Lease.t()]
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
