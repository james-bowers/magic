defmodule Magic.EventStore do
  @moduledoc """
  Behaviour for storage & reading of events
  """

  @type aggregate :: String.t()
  @type events :: List.t()

  @callback commit(aggregate, events) :: nil

  @callback load(aggregate) :: events
end
