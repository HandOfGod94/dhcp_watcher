defmodule DhcpWatcher.LeaseTest do
  use ExUnit.Case
  doctest DhcpWatcher.Lease
  alias DhcpWatcher.Lease

  @assigned_lease """
  lease 192.168.0.1 {
    starts 6 2021/02/20 14:11:36;
    ends 6 2021/02/20 14:21:36;
    cltt 6 2021/02/20 14:11:36;
    binding state active;
    next binding state free;
    rewind binding state free;
    hardware ethernet 12:ab:CD:78:90:91;
    uid "\001\204\330\033E\023=";
    set vendor-class-identifier = "MSFT 5.0";
    client-hostname "MyLocalClient";
  }
  """

  test "module exists" do
    assert is_atom(Lease.__info__(:module))
  end

  test "extract ip address" do
    line = "lease 192.168.0.100 {"
    assert Lease.parse(Lease.new, line) == %Lease{ip_address: "192.168.0.100"}
  end

  test "extract client name" do
    line = ~s(client-hostname "MyLocalClient";)
    assert Lease.parse(Lease.new, line) == %Lease{hostname: "MyLocalClient"}
  end

  test "extract lease end" do
    line = ~s(ends 6 2021/02/20 14:21:36;)
    assert Lease.parse(Lease.new, line) == %Lease{lease_end: ~N[2021-02-20 14:21:36]}
  end

  test "extract mac address" do
    line = ~s(hardware ethernet 12:ab:CD:78:90:91;)
    assert Lease.parse(Lease.new, line) == %Lease{mac_address: "12:ab:CD:78:90:91"}
  end

  test "parse assigned lease" do
    assert %Lease{
      ip_address: "192.168.0.1",
      hostname: "MyLocalClient",
      mac_address: "12:ab:CD:78:90:91",
      lease_end: ~N[2021-02-20 14:21:36]
    } == Lease.parse(@assigned_lease)
  end
end
