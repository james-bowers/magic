defmodule Magic.AggregateRegistryTest do
  use ExUnit.Case

  setup do
    Test.Support.AggregateRegistry.start_link()
    Test.Support.AggregateSupervisor.start_link([])

    :ok
  end

  test "can start one aggregate registry" do
    Test.Support.AggregateRegistry.start_link()

    assert {:error, {:already_started, already_started_pid}} =
             Test.Support.AggregateRegistry.start_link()
  end

  test "creates a new aggregate." do
    assert pid =
             Test.Support.AggregateRegistry.find_or_start(
               Test.Support.AggregateOne,
               "agg-12345"
             )
  end
end
