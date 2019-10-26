defmodule Magic do
  def load(aggregate) do
    # load from postgres and deserialise
  end

  def commit(aggregate, events) when is_list(events) do
    # store()

    # notify()
  end

  defp notify(_aggregate, []), do: :ok

  defp notify(aggregate, [event | events]) do
    Magic.Distribute.distribute({aggregate, event})

    notify(aggregate, events)
  end
end
