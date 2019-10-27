defmodule Example do
  @moduledoc """
  Documentation for Example.
  """
  def increment(agg) do
    Example.AggregateRegistry.find_or_start(Example.CounterAggregate, agg)
    Example.CounterAggregate.run(agg, %Example.Increment{increment_by: 1})
  end
end
