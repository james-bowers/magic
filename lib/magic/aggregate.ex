defmodule Magic.Aggregate do
  @moduledoc """
  `use`able template for creating an aggregate.

  In setup options, a callback module will be given
  to calculate the current state and whether the next 
  `wish` is valid and the state caused because of it.
  """
  defmacro __using__(which) do
    quote do
      use GenEvent

      def run(aggregate_id, wish) do
        via_tuple(aggregate_id) |> GenServer.call({aggregate_id, wish})
      end

      def start_link(aggregate_id) do
        name = via_tuple(aggregate_id)

        Registry.start_link(keys: :unique, name: :my_registry)

        case GenServer.start_link(__MODULE__, {aggregate_id}, name: name) do
          {:ok, _} ->
            GenServer.cast(name, :read_to_get_current_state)
            :ok

          {:error, {:already_started, _}} ->
            :ok
        end
      end

      defp via_tuple(aggregate_id) do
        {:via, Registry, {:my_registry, aggregate_id}}
      end

      # callbacks
      #
      def init({aggregate_id}) do
        {:ok, %{aggregate_id: aggregate_id}}
      end

      def handle_cast(:read_to_get_current_state, state) do
        # events = if state.aggregate_id, do: EventStore.load(state.aggregate_id), else: []
        events = []

        {:noreply, state_from_events(events) || nil}
      end

      def handle_call({aggregate_id, wish}, _from, state) do
        case __MODULE__.execute(state, wish) do
          {:ok, new_event} ->

            # calculate the new state
            {:ok, new_state} = __MODULE__.next_state(state, new_event)

            # TODO: store the new event (now the new state has been generated successfully)
            # EventStore.commit(aggregate_id, new_event)
            IO.inspect("save new events...")

            {:reply, :ok, new_state}

          error_result = {:error, _} ->
            # something went wrong, so keep current state, and return error
            {:reply, error_result, state}
        end
      end

      defp state_from_events(events) do
        events
        |> Enum.reduce(nil, fn event, state -> __MODULE__.next_state(event, state) end)
      end
    end
  end
end

# defmodule James do
#   use Magic.Aggregate

#   def execute(current_state, wish) do
#     IO.inspect(current_state, label: "execute")

#     {:ok, %{this_is: "a new event"}}
#   end

#   def next_state(current_state, event) do
#     IO.inspect(event, label: "calc next state from event")

#     {:ok, event}
#   end
# end
