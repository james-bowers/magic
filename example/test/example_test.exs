defmodule ExampleTest do
  use ExUnit.Case

  test "increments a counter" do
    Example.CounterAggregate.run("counter_one", %Example.Increment{increment_by: 1})
  end
end
