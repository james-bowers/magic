defmodule Test.Support.AggregateOne do
  use Magic.Aggregate

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
