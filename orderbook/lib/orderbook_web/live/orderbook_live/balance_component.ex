defmodule OrderbookWeb.OrderbookLive.BalanceComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    if connected?(socket) do
      Orderbook.Balance.subscribe()
    end

    balances =
      Orderbook.Balance.get_list()
      |> get_list()
    {:ok, assign(socket, balances: balances), temporary_assigns: [balances: []]}
  end

  def update(assigns, socket) do
    socket = if assigns[:balances] do
        assign(socket, :balances, get_list(assigns[:balances]))
    else
      socket
    end
    {:ok, socket}
  end

  defp get_list(balances) do
    balances
      |> Enum.map(fn balance ->
        value = case balance.currency do
          "USDt" -> balance.margin/1000000
          "Gwei" -> balance.margin/1000000000
          "XBt" -> balance.margin/100000000
        end
        currency = case balance.currency do
          "USDt" -> "USDT"
          "Gwei" -> "ETH"
          "XBt" -> "BTC"
        end
        "#{value} #{currency}"
      end)
  end


end
