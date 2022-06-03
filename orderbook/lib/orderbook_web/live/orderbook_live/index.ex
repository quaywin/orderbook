defmodule OrderbookWeb.OrderbookLive.Index do
  use OrderbookWeb, :live_view

  def handle_info({:orderbook_fetched, new_items}, socket) do
    send_update OrderbookWeb.OrderbookLive.OrderbookComponent, id: "orderbook", orderbooks: new_items
    {:noreply, socket}
  end

  def handle_info({:balance_fetched, new_items}, socket) do
    send_update OrderbookWeb.OrderbookLive.BalanceComponent, id: "balance", balances: new_items
    {:noreply, socket}
  end

  def handle_info({:order_fetched, new_items}, socket) do
    send_update OrderbookWeb.OrderbookLive.OrderComponent, id: "order", orders: new_items
    {:noreply, socket}
  end

  def handle_info({:position_fetched, new_items}, socket) do
    send_update OrderbookWeb.OrderbookLive.PositionComponent, id: "position", positions: new_items
    {:noreply, socket}
  end
end
