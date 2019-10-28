defmodule Magic.AggregateRegistry do
  defmacro __using__(aggregate_supervisor: aggregate_supervisor) do
    quote do
      def start_link do
        Registry.start_link(keys: :unique, name: __MODULE__)
      end

      def find_or_start(aggregate_module, aggregate_id) do
        case Registry.lookup(__MODULE__, aggregate_id) do
          [{pid, _}] ->
            pid

          [] ->
            unquote(aggregate_supervisor).start_aggregate(aggregate_module, aggregate_id)
        end
      end

      def via_tuple(aggregate_id) do
        {:via, Registry, {__MODULE__, aggregate_id}}
      end

      def child_spec(_) do
        Supervisor.child_spec(
          Registry,
          id: __MODULE__,
          start: {__MODULE__, :start_link, []}
        )
      end
    end
  end
end
