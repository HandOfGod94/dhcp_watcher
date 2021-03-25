defmodule DhcpWatcher.LeaseTest do
  use ExUnit.Case, async: true
  alias DhcpWatcher.Lease
  doctest DhcpWatcher.Lease

  @unassigned_lease """
  lease 192.168.0.100 {
    starts 3 2021/02/24 12:48:54;
    ends 3 2021/02/24 14:48:54;
    tstp 3 2021/02/24 14:48:54;
    cltt 3 2021/02/24 12:48:54;
    binding state free;
    uid "\001\306\325J\035\372'";
  }
  """

  test "parse unassigned_lease" do
    assert %Lease{
             ip_address: "192.168.0.100",
             hostname: "",
             is_active: false,
             mac_address: "",
             lease_end: ~N[2021-02-24 14:48:54]
           } == Lease.parse(@unassigned_lease)
  end
end
