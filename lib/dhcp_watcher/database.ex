defmodule DhcpWatcher.Database do
  alias DhcpWatcher.Lease

  def read(content) do
    content
    |> String.trim()
    |> String.split("}")
    |> Stream.filter(&(&1 != ""))
    |> Enum.map(&Lease.parse/1)
  end
end
