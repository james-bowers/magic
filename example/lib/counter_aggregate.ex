defmodule Example.CounterAggregate do
  use Magic.Aggregate,
    aggregate_registry: Example.AggregateRegistry,
    event_store: Example.EventStore

  def execute(current_state, %Example.Increment{increment_by: increment_by}) do
    {:ok, %Example.Incremented{increment_by: increment_by}}
  end

  def next_state(nil, %Example.Incremented{increment_by: increment_by}) do
    increment_by
  end

  def next_state(current_state, %Example.Incremented{increment_by: increment_by}) do
    current_state + increment_by
  end
end
