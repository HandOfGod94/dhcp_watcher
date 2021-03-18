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

  @unassigned_lease """
  lease 192.168.0.100 {
    starts 3 2021/02/24 12:48:54;
    ends 3 2021/02/24 14:48:54;
    tstp 3 2021/02/24 14:48:54;
    cltt 3 2021/02/24 12:48:54;
    binding state free;
    hardware ethernet 12:ab:CD:78:90:91;
    uid "\001\306\325J\035\372'";
  }
  """

  test "module exists" do
    assert is_atom(Lease.__info__(:module))
  end

  test "extract ip address" do
    line = "lease 192.168.0.100 {"
    assert Lease.parse(Lease.new(), line) == %Lease{ip_address: "192.168.0.100"}
  end

  test "extract client name" do
    line = ~s(client-hostname "MyLocalClient";)
    assert Lease.parse(Lease.new(), line) == %Lease{hostname: "MyLocalClient"}
  end

  test "extract lease end" do
    line = ~s(ends 6 2021/02/20 14:21:36;)
    assert Lease.parse(Lease.new(), line) == %Lease{lease_end: ~N[2021-02-20 14:21:36]}
  end

  test "extract mac address" do
    line = ~s(hardware ethernet 12:ab:CD:78:90:91;)
    assert Lease.parse(Lease.new(), line) == %Lease{mac_address: "12:ab:CD:78:90:91"}
  end

  test "extract state" do
    line = ~s(binding state active;)
    assert Lease.parse(Lease.new(), line) == %Lease{is_active: true}
  end

  test "parse assigned lease" do
    assert %Lease{
             ip_address: "192.168.0.1",
             hostname: "MyLocalClient",
             is_active: true,
             mac_address: "12:ab:CD:78:90:91",
             lease_end: ~N[2021-02-20 14:21:36]
           } == Lease.parse(@assigned_lease)
  end

  test "parse unassigned_lease" do
    assert %Lease{
             ip_address: "192.168.0.100",
             hostname: nil,
             is_active: false,
             mac_address: "12:ab:CD:78:90:91",
             lease_end: ~N[2021-02-24 14:48:54]
           } == Lease.parse(@unassigned_lease)
  end
end
