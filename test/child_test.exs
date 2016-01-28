defmodule App.ChildTest do
 use ExUnit.Case, async: true

  setup do
    {:ok, child} = App.Child.start_link("some_name")
    {:ok, child: child}
  end

  test "spawns child", %{child: child} do
    assert App.Child.say_hey(child) == {:ok, "'some_name' says hey!"}
  end

  test ":kill child", %{child: child} do
    assert Process.alive?(child) == true
    App.Child.kill(child)
    assert Process.alive?(child) == false
  end
end
