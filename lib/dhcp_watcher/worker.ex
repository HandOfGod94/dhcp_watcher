defmodule DhcpWatcher.Worker do
  use GenServer
  require Logger
  alias DhcpWatcher.{Database, Instrumenter}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, watcher} = FileSystem.start_link(args)
    FileSystem.subscribe(watcher)

    Logger.info("file watcher started")
    {:ok, %{watcher: watcher}}
  end

  def handle_info({:file_event, _watcher, {path, _events}}, state) do
    Logger.info("received file change event")

    path
    |> File.read!()
    |> Database.get_all_lease()
    |> Enum.each(&Instrumenter.publish_lease/1)

    {:noreply, state}
  end

  def handle_info({:file_event, _watcher, :stop}, state) do
    Logger.info("Stopping file watcher")
    {:noreply, state}
  end
end
