defmodule Test.Support.AggregateRegistry do
  use Magic.AggregateRegistry, aggregate_supervisor: Test.Support.AggregateSupervisor
end
