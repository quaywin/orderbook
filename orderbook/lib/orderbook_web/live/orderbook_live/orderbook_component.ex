defmodule OrderbookWeb.OrderbookLive.OrderbookComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    if connected?(socket) do
      Orderbook.Orderbook.subscribe()
    end

    orderbooks =
      Orderbook.Orderbook.get_list()
      |> get_list()

    {:ok, assign(socket, orderbooks: orderbooks), temporary_assigns: [orderbooks: []]}
  end

  def update(assigns, socket) do
    socket = if assigns[:orderbooks] do
        assign(socket, :orderbooks, get_list(assigns[:orderbooks]))
    else
      socket
    end
    {:ok, socket}
  end

  defp orderbook_column(list_buy, list_sell, buy, sell, index) do
    {
      Map.put(buy, :total, get_total(list_buy, buy, index)),
      Map.put(sell, :total, get_total(list_sell, sell, index))
    }
  end

  defp get_total(list, item, index) do
    if index > 0 do
      list
      |> Enum.take(index + 1)
      |> Enum.map(fn el -> el.size end)
      |> Enum.reduce(fn x, acc -> x + acc end)
    else
      item.size
    end
  end

  defp get_list(orderbooks) do
    list_buy =
      orderbooks
      |> Enum.filter(fn order -> order.side == "Buy" end)
      |> Enum.sort_by(& &1.price, :desc)
      |> Enum.take(15)

    list_sell =
      orderbooks
      |> Enum.filter(fn order -> order.side == "Sell" end)
      |> Enum.sort_by(& &1.price, :asc)
      |> Enum.take(15)

    list_buy
    |> Enum.with_index()
    |> Enum.map(fn {buy, index} ->
      orderbook_column(list_buy, list_sell, buy, Enum.at(list_sell, index), index)
    end)
  end
end
