defmodule App.Child do
  use GenServer
  require Logger

  ################## Client API ##################

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, [])
  end

  def say_hey(server) do
    GenServer.call(server, {:say_hey})
  end

  def kill(server) do
    GenServer.cast(server, {:announce_death})
    GenServer.stop(server)
  end


  ################## Server Callbacks ##################

  def init(name) do
    Logger.debug "Starting App.Child with name #{name}!"
    {:ok, %{name: name}}
  end

  def handle_call({:say_hey}, _from, state) do
    msg = "'#{state[:name]}' says hey!"
    Logger.info msg
    {:reply, {:ok, msg}, state}
  end

  def handle_cast({:announce_death}, state) do
    Logger.warn "'#{state[:name]}' is dying!"
     {:noreply, state}
  end
end