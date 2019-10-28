defmodule ExampleTest do
  use ExUnit.Case

  test "increments counters individually" do
    Example.increment("counter", %Example.Increment{increment_by: 1})
    Example.increment("counter", %Example.Increment{increment_by: 5})
    Example.increment("counter", %Example.Increment{increment_by: 7})

    Example.increment("counter_two", %Example.Increment{increment_by: 50})

    assert 13 == Example.CounterAggregate.current_state("counter")
    assert 50 == Example.CounterAggregate.current_state("counter_two")
  end
end
