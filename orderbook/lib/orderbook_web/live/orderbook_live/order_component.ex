defmodule OrderbookWeb.OrderbookLive.OrderComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    if connected?(socket) do
      Orderbook.Order.subscribe()
    end

    orders =
      Orderbook.Order.get_list()
      |> get_list()
    {:ok, assign(socket, orders: orders), temporary_assigns: [orders: []]}
  end

  def update(assigns, socket) do
    socket = if assigns[:orders] do
        assign(socket, :orders, get_list(assigns[:orders]))
    else
      socket
    end
    {:ok, socket}
  end

  defp get_list(orders) do
    orders
      |> Enum.filter(fn order -> order.status == "New" end)
      |> Enum.map(fn order ->
        style = case order.side do
          "Buy" -> "text-green-600"
          "Sell" -> "text-red-600"
        end
        Map.put(order, :style, style)
      end)
  end
end
