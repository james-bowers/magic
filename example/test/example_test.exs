defmodule ExampleTest do
  use ExUnit.Case

  test "increments counters individually" do
    assert 1 == Example.increment("counter")
    assert 2 == Example.increment("counter")
    assert 3 == Example.increment("counter")

    assert 1 == Example.increment("counter_two")
    assert 2 == Example.increment("counter_two")
  end
end
