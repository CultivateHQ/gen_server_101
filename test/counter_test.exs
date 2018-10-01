defmodule CounterTest do
  use ExUnit.Case

  test "initialising" do
    {:ok, pid} = Counter.start_link(7)
    assert Counter.value(pid) == 7
  end

  test "incrementing" do
    {:ok, pid} = Counter.start_link(4)
    Counter.increment(pid)
    assert Counter.value(pid) == 5
  end

  # Remove this tag
  @tag skip: true
  test "decrementing" do
    {:ok, pid} = Counter.start_link(4)
    Counter.decrement(pid)
    assert Counter.value(pid) == 3
  end

  # Remove this tag
  @tag skip: true
  test "increment after" do
    {:ok, pid} = Counter.start_link(4)
    Counter.increment_after(pid, 40)
    assert Counter.value(pid) == 4

    assert_receive {:counter_incremented, {^pid, 5}}
  end
end
