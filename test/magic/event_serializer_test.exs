defmodule Magic.EventSerializerTest do
  use ExUnit.Case

  alias Magic.EventSerializer

  defmodule MyStruct do
    defstruct [:a_key]
  end

  test "serialises an empty struct" do
    assert ~s({"__struct__":"Elixir.Magic.EventSerializerTest.MyStruct","a_key":null}) ==
             EventSerializer.serialize(%MyStruct{})
  end

  test "deserialises a serialised struct" do
    my_struct = %MyStruct{a_key: "b"}
    serialised = EventSerializer.serialize(my_struct)
    assert my_struct == EventSerializer.deserialize(serialised)
  end
end
