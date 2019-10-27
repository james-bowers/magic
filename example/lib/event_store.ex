defmodule Example.EventStore do
  @behaviour Magic.EventStore

  def commit(aggregate, events), do: :ok

  def load(_), do: []
end
