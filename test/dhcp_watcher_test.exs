defmodule DhcpWatcherTest do
  use ExUnit.Case, async: true
  doctest DhcpWatcher
  alias DhcpWatcher.Lease

  describe "with valid database" do
    @valid """
    # some comment at top
    lease 192.168.0.99 {
      starts 6 2021/02/20 14:11:36;
      ends 6 2025/02/20 14:21:36;
      cltt 6 2021/02/20 14:11:36;
      binding state active;
      next binding state free;
      rewind binding state free;
      hardware ethernet 12:ab:CD:78:90:91;
      uid "\001\204\330\033E\023=";
      set vendor-class-identifier = "MSFT 5.0";
      client-hostname "MyLocalClient";
    }
    lease 192.168.0.99 {
      starts 6 2021/02/20 14:11:36;
      ends 6 2025/02/20 05:21:36;
      cltt 6 2021/02/20 14:11:36;
      binding state active;
      next binding state free;
      rewind binding state free;
      hardware ethernet 12:ab:CD:78:90:91;
      uid "\001\204\330\033E\023=";
      set vendor-class-identifier = "MSFT 5.0";
      client-hostname "MyLocalClient";
    }
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

    test "parsing success" do
      result = DhcpWatcher.get_all_lease(@valid)

      assert result == [
               %Lease{
                 ip_address: "192.168.0.99",
                 lease_end: ~N[2025-02-20 14:21:36],
                 is_active: true,
                 mac_address: "12:ab:CD:78:90:91",
                 hostname: "MyLocalClient"
               },
               %Lease{
                 ip_address: "192.168.0.99",
                 lease_end: ~N[2025-02-20 05:21:36],
                 is_active: true,
                 mac_address: "12:ab:CD:78:90:91",
                 hostname: "MyLocalClient"
               },
               %Lease{
                 ip_address: "192.168.0.1",
                 lease_end: ~N[2021-02-20 14:21:36],
                 is_active: true,
                 mac_address: "12:ab:CD:78:90:91",
                 hostname: "MyLocalClient"
               },
               %Lease{
                 ip_address: "192.168.0.100",
                 lease_end: ~N[2021-02-24 14:48:54],
                 is_active: false,
                 mac_address: "12:ab:CD:78:90:91",
                 hostname: ""
               }
             ]
    end

    test "get_active_lease/0 - returns only active lease after deduping that will expire in future" do
      result = DhcpWatcher.get_future_lease(@valid)

      assert result == [
               %Lease{
                 ip_address: "192.168.0.99",
                 lease_end: ~N[2025-02-20 14:21:36],
                 is_active: true,
                 mac_address: "12:ab:CD:78:90:91",
                 hostname: "MyLocalClient"
               }
             ]
    end
  end

  test "return empty database for invalid format" do
    assert DhcpWatcher.get_all_lease("foo") == [%Lease{}]
  end
end
