defmodule App do
  import Supervisor.Spec
  require Logger

  def one_for_one do
    sup_pid = create_supervision_tree(:one_for_one)
    spawn_link(fn() -> main_loop(sup_pid) end)
  end

  def one_for_all do
    sup_pid = create_supervision_tree(:one_for_all)
    spawn_link(fn() -> main_loop(sup_pid) end)
  end

  def rest_for_one do
    sup_pid = create_supervision_tree(:rest_for_one)
    spawn_link(fn() -> main_loop(sup_pid) end)
  end

  ###################### Private ######################

  defp create_supervision_tree(strategy) do
    children = create_children(10)
    {:ok, sup_pid} = Supervisor.start_link(children, strategy: strategy)
    sup_pid
  end

  defp create_children(n) do
    (1..n)
      |> Enum.map(fn(i) ->
        name = "child_#{i}"
        worker(App.Child, [name], [id: name])
      end)
  end

  def main_loop(sup_pid) do
    children_pids = Supervisor.which_children(sup_pid) |> Enum.map(&(elem(&1, 1)))
    kill_round(children_pids)
    main_loop(sup_pid)
  end

  defp kill_round(children_pids) do
    children_pids
      |> Enum.each(fn(c) ->
          random_killer(c)
      end)
  end

  defp random_killer(child_pid) do
    if Process.alive? child_pid do
      case Enum.random 1..10 do
        1 -> App.Child.kill(child_pid)
        _ -> App.Child.say_hey(child_pid)
      end
      :timer.sleep(1000)
    end
  end
end
