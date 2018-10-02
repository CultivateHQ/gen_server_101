defmodule ProcessFunTest do
  use ExUnit.Case

  test "initialise qmueryable counter" do
    pid = ProcessFun.start_queryable_counter(5)
    assert ProcessFun.queryable_counter_value(pid) == 5
  end

  test "incrementing queryable counter" do
    pid = ProcessFun.start_queryable_counter(1)
    ProcessFun.increment_queryable_counter(pid)
    assert ProcessFun.queryable_counter_value(pid) == 2
  end

  test "decrementing queryable counter" do
    pid = ProcessFun.start_queryable_counter(1)
    ProcessFun.decrement_queryable_counter(pid)
    assert ProcessFun.queryable_counter_value(pid) == 0
  end
end
