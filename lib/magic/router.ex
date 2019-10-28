defmodule Magic.Router do
    defmacro defaction(action, route_to: {aggregate_registry, aggregate}) do
      quote do
        def unquote(action)(aggregate_id, wish) do
          unquote(aggregate_registry).find_or_start(unquote(aggregate), aggregate_id)
          unquote(aggregate).run(aggregate_id, wish)
        end
      end
    end
end
