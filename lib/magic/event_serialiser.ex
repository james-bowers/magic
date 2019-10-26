defmodule Magic.EventSerializer do
  @moduledoc """
  For storage of events into the event store.
  """

  def serialize(event) do
    event
    |> Map.from_struct()
    |> Map.merge(%{__struct__: to_string(event.__struct__)})
    |> Jason.encode!()
  end

  def deserialize(serialized_event) do
    serialized_event
    |> Jason.decode!(keys: :atoms)
    |> decode()
  end

  def decode(event_map) do
    new_event = event_map |> Enum.reduce(%{}, fn {key, val}, acc -> Map.put(acc, key, val) end)
    [Map.fetch!(new_event, :__struct__)] |> Module.concat() |> struct(new_event)
  end
end
