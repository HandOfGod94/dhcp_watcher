defmodule DhcpWatcher.DatabaseTest do
  use ExUnit.Case
  doctest DhcpWatcher.Database
  alias DhcpWatcher.{Database, Lease}

  describe "with valid database" do
    @valid """
    # some comment at top
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
      result = Database.read(@valid)

      assert result == [
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
                 hostname: nil
               }
             ]
    end
  end

  test "return empty database for invalid format" do
    assert Database.read("foo") == [%Lease{}]
  end
end
