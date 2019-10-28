defmodule Example.AggregateSupervisor do
  use Magic.AggregateSupervisor, aggregate_registry: Example.AggregateRegistry
end
