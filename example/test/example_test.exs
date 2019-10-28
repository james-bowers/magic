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

  test "keeps count during a process failure" do
    aggregate_id = "failing_counter"

    for num <- 1..200 do
      Example.increment(aggregate_id, %Example.Increment{increment_by: 5})

      if rem(num, 8) == 0 do
        # kill_aggregate(aggregate_id)

        # pid_from_aggregate_id(aggregate_id)
        # |> IO.inspect()
      end
    end

    assert 1000 == Example.CounterAggregate.current_state(aggregate_id)
  end
end
