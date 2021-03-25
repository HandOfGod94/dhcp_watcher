defmodule DhcpWatcher.Lease do
  @moduledoc """
  Parser for individual lease entry in `dhcp.lease` file

  ## Examples


    iex> raw_lease = ~s(
    ...>   lease 192.168.0.1 {
    ...>     starts 6 2021/02/20 14:11:36;
    ...>     ends 6 2021/02/20 14:21:36;
    ...>     cltt 6 2021/02/20 14:11:36;
    ...>     binding state active;
    ...>     next binding state free;
    ...>     rewind binding state free;
    ...>     hardware ethernet 12:ab:CD:78:90:91;
    ...>     uid "\001\204\330\033E\023=";
    ...>     set vendor-class-identifier = "MSFT 5.0";
    ...>     client-hostname "MyLocalClient";
    ...>   }
    ...> )
    iex> Lease.parse(raw_lease)
    %Lease{ip_address: "192.168.0.1", hostname: "MyLocalClient", is_active: true, mac_address: "12:ab:CD:78:90:91", lease_end: ~N[2021-02-20 14:21:36]}
  """

  @type t :: %__MODULE__{
          ip_address: binary() | nil,
          lease_end: NaiveDateTime.t() | nil,
          hostname: binary(),
          mac_address: binary(),
          is_active: boolean()
        }

  @derive Jason.Encoder
  defstruct [:ip_address, :lease_end, hostname: "", mac_address: "", is_active: false]

  @spec new() :: t()
  def new, do: %__MODULE__{}

  @spec parse(binary()) :: t()
  def parse(lines) do
    String.trim(lines)
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Enum.reduce(new(), &do_parse/2)
  end

  defp do_parse(line, lease) do
    case line do
      "lease " <> msg ->
        %{lease | ip_address: extract({:ip_address, msg})}

      "client-hostname " <> msg ->
        %{lease | hostname: extract({:hostname, msg})}

      "ends " <> msg ->
        %{lease | lease_end: extract({:lease_end, msg})}

      "hardware ethernet " <> msg ->
        %{lease | mac_address: extract({:mac_address, msg})}

      "binding state active;" ->
        %{lease | is_active: true}

      _ ->
        lease
    end
  end

  defp extract({:ip_address, msg}), do: String.replace_suffix(msg, " {", "")

  defp extract({:hostname, msg}) do
    msg |> String.replace(";", "") |> String.replace(~s("), "")
  end

  defp extract({:mac_address, msg}) do
    msg |> String.trim_trailing(";")
  end

  defp extract({:lease_end, msg}) do
    tokens = String.split(msg)
    time = Enum.at(tokens, -1) |> String.trim_trailing(";")
    date = Enum.at(tokens, -2) |> String.replace("/", "-")
    NaiveDateTime.from_iso8601!(date <> " " <> time)
  end
end
