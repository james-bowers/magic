defmodule Magic.AggregateTest do
  use ExUnit.Case
  use EventStore.Test.Support.Helper, :mox

  @aggregate "aggregate-1234567"

  setup do
    Registry.start_link(keys: :unique, name: :aggregate_registry)
    Test.Support.AggregateOne.start_link(@aggregate)
    :ok
  end

  test "loads the aggregate on start_link" do
    EventStoreMock
    |> expect(:load, fn @aggregate -> [%{previous_event: "hello"}] end)

    EventStoreMock
    |> expect(:commit, fn @aggregate, %{this_is: "a new event"} -> :ok end)

    assert :ok == Test.Support.AggregateOne.run(@aggregate, %{my: "wish"})

    assert %{this_is: "a new event", previous_event: "hello"} ==
             Test.Support.AggregateOne.current_state(@aggregate)
  end
end
