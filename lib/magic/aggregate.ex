defmodule Magic.Aggregate do
  @moduledoc """
  A process to track an aggregate, that
  calls callback functions to update
  state from previous events, and to create new events.
  """
  @type reason :: atom()
  @type current_state :: any
  @type new_state :: any
  @type event :: any
  @type wish :: any

  @callback execute(current_state, wish) :: {:ok, event} | {:error, reason}
  @callback next_state(current_state, event) :: new_state

  defmacro __using__(aggregate_registry: aggregate_registry, event_store: event_store) do
    quote do
      @event_store unquote(event_store)
      use GenServer

      def run(aggregate_id, wish) do
        via_tuple(aggregate_id) |> GenServer.call({aggregate_id, wish})
      end

      def current_state(aggregate_id) do
        via_tuple(aggregate_id) |> GenServer.call(:state)
      end

      def start_link(aggregate_id) do
        name = via_tuple(aggregate_id)

        case GenServer.start_link(__MODULE__, nil, name: name) do
          {:ok, _} ->
            GenServer.cast(name, {:read_to_get_current_state, aggregate_id})
            :ok

          {:error, {:already_started, _}} ->
            :ok
        end
      end

      defp via_tuple(aggregate_id) do
        # {:via, unquote(aggregate_registry), aggregate_id}
        unquote(aggregate_registry).via_tuple(aggregate_id)
      end

      # callbacks
      #
      def init(init_value) do
        {:ok, init_value}
      end

      def handle_cast({:read_to_get_current_state, aggregate_id}, state) do
        events = @event_store.load(aggregate_id)

        {:noreply, state_from_events(events) || nil}
      end

      def handle_call({aggregate_id, wish}, _from, state) do
        with {:ok, new_event} <- __MODULE__.execute(state, wish),
             new_state <- __MODULE__.next_state(state, new_event),
             :ok <- @event_store.commit(aggregate_id, new_event) do
          {:reply, :ok, new_state}
        else
          error -> error
        end
      end

      def handle_call(:state, _from, state) do
        {:reply, state, state}
      end

      defp state_from_events(events) do
        events
        |> Enum.reduce(nil, &__MODULE__.next_state(&2, &1))
      end
    end
  end
end
