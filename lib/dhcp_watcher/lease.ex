defmodule DhcpWatcher.Lease do
  defstruct [:ip_address, :hostname, :mac_address, :lease_end]

  def new, do: %__MODULE__{}

  def parse(lines) do
    String.trim(lines)
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(new(), fn line, lease -> parse(lease, line) end)
  end

  def parse(lease, line) do
    case line do
      "lease " <> msg ->
        %{lease | ip_address: extract({:ip_address, msg})}

      "client-hostname " <> msg ->
        %{lease | hostname: extract({:hostname, msg})}

      "ends " <> msg ->
        %{lease | lease_end: extract({:lease_end, msg})}

      "hardware " <> msg ->
        %{lease | mac_address: extract({:mac_address, msg})}

      _ ->
        lease
    end
  end

  defp extract({:ip_address, msg}), do: String.replace_suffix(msg, " {", "")

  defp extract({:hostname, msg}) do
    msg |> String.replace(";", "") |> String.replace(~s("), "")
  end

  defp extract({:mac_address, msg}) do
    tokens = msg |> String.split(" ")
    tokens |> Enum.at(-1) |> String.trim_trailing(";")
  end

  defp extract({:lease_end, msg}) do
    tokens = String.split(msg)
    time = Enum.at(tokens, -1) |> String.trim_trailing(";")
    date = Enum.at(tokens, -2) |> String.replace("/", "-")
    NaiveDateTime.from_iso8601!(date <> " " <> time)
  end
end
