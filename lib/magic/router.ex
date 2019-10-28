defmodule Magic.Router do
  defmacro defaction(action, route_to: {registry, aggregate}) do
    quote do
      def unquote(action)(aggregate_id, wish) do
        Magic.handle(%Magic{
          registry: unquote(registry),
          aggregate: unquote(aggregate),
          aggregate_id: aggregate_id,
          wish: wish
        })
      end
    end
  end
end
