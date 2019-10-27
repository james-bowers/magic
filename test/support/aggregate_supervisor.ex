defmodule Test.Support.AggregateSupervisor do
  use Magic.AggregateSupervisor, aggregate_registry: Test.Support.AggregateRegistry
end
