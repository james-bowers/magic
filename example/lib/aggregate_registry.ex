defmodule Example.AggregateRegistry do
  use Magic.AggregateRegistry, aggregate_supervisor: Example.AggregateSupervisor
end
