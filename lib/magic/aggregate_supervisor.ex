defmodule Magic.AggregateSupervisor do
  defmacro __using__(aggregate_registry: aggregate_registry) do
    quote do
      use DynamicSupervisor

      def start_link(_options),
        do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

      def init(:ok),
        do: DynamicSupervisor.init(strategy: :one_for_one)

      def start_aggregate(aggregate, aggregate_id),
        do: DynamicSupervisor.start_child(__MODULE__, {aggregate, aggregate_id})

      def children,
        do: DynamicSupervisor.which_children(__MODULE__)

      def count,
        do: DynamicSupervisor.count_children(__MODULE__)

      def kill_aggregate(aggregate_id) do
        DynamicSupervisor.terminate_child(__MODULE__, pid_from_aggregate_id(aggregate_id))
      end

      def pid_from_aggregate_id(aggregate_id) do
        aggregate_id
        |> unquote(aggregate_registry).via_tuple() 
        |> GenServer.whereis()
      end
    end
  end
end

# Example.increment("one", %Example.Increment{increment_by: 1})
# Example.AggregateSupervisor.pid_from_aggregate_id("one")
# Example.AggregateSupervisor.kill_aggregate("one")