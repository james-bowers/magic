defmodule Magic.AggregateSupervisor do
  defmacro __using__(_opts) do
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
    end
  end
end
