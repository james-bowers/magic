defmodule Example do
  @moduledoc """
  Documentation for Example.
  """

  import Magic.Router

  defaction(:increment, route_to: {Example.AggregateRegistry, Example.CounterAggregate})
end
