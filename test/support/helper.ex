defmodule EventStore.Test.Support.Helper do
  def mox do
    quote do
      import Mox
      setup :verify_on_exit!
      setup :set_mox_global

      @func_never_called 0
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
