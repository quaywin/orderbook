defmodule OrderbookWeb.OrderbookLive.PlaceOrderComponent do
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS


  def mount(socket) do
    {:ok, assign(socket, size: 0), temporary_assigns: [size: 0]}
  end

  def handle_event("buy_limit", _, socket) do
    socket = assign(socket, :state, "buy_limit")
    # save_user(socket, socket.assigns.action, user_params)
    {:noreply, socket}
  end

  def handle_event("save", param, socket) do
    IO.inspect(param)
    IO.inspect(socket.assigns)
    # save_user(socket, socket.assigns.action, user_params)
    {:noreply, socket}
  end
end
