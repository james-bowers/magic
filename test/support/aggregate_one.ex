defmodule Test.Support.AggregateOne do
  use Magic.Aggregate,
    aggregate_registry: Test.Support.AggregateRegistry,
    event_store: EventStoreMock

  def execute(current_state, wish) do
    {:ok, %{this_is: "a new event"}}
  end

  def next_state(nil, event) do
    event
  end

  def next_state(current_state, event) do
    Map.merge(current_state, event)
  end
end
