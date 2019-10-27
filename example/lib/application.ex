defmodule Example.Application do
  use Application

  def start(_type, _args) do
    children = [
      Example.AggregateRegistry,
      Example.AggregateSupervisor
    ]

    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
