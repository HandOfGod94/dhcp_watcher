defmodule DhcpWatcher.WorkerTest do
  use ExUnit.Case, async: true
  doctest DhcpWatcher.Worker
  alias DhcpWatcher.Worker

  @path Application.get_env(:dhcp_watcher, :dhcp_file)

  setup do
    on_exit(fn -> File.rm_rf!(@path) end)
    Worker.init(dirs: [@path], latency: 0)
  end

  test "watches file created event", %{watcher: watcher} do
    File.touch!(@path)
    expected_path = "/private" <> @path
    assert_receive {:file_event, ^watcher, {^expected_path, events}}, 2000
    assert Enum.member?(events, :created)
  end
end
