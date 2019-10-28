defmodule Magic do
  defstruct registry: nil,
            aggregate: nil,
            aggregate_id: nil,
            wish: nil,
            event: nil,
            strong_consistency?: true

  def handle(magic) do
    magic
    |> ensure_aggregate_started()
    |> dispatch_to_aggregate()
    |> notify_listeners()
  end

  defp ensure_aggregate_started(
         magic = %Magic{
           registry: registry,
           aggregate: aggregate,
           aggregate_id: aggregate_id
         }
       ) do
    registry.find_or_start(aggregate, aggregate_id)

    magic
  end

  defp dispatch_to_aggregate(
         magic = %Magic{aggregate: aggregate, aggregate_id: aggregate_id, wish: wish}
       ) do
    {:ok, new_event} = aggregate.dispatch(aggregate_id, wish)

    Map.put(magic, :event, new_event)
  end

  defp notify_listeners(magic) do
    # IO.inspect(magic, label: "notify listeners of")
    # TODO: notify listeners of the event that has occured.
    # Vary on `strong_consistency?` to either wait for
    # all listeners to acknowledge the event as success,
    # or return immediately here.

    magic
  end
end
