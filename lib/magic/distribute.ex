defmodule Magic.Distribute do
  @handlers [CounterEventHandler]

  def distribute(_, []), do: :ok

  def distribute({uuid, event}, [handler | handlers] \\ @handlers) do
    :ok = handler.handle(event)
    distribute({uuid, event}, handlers)
  end
end
