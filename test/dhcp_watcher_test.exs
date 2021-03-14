defmodule DhcpWatcherTest do
  use ExUnit.Case
  doctest DhcpWatcher

  test "greets the world" do
    assert DhcpWatcher.hello() == :world
  end
end
