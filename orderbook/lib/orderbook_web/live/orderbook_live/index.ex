defmodule OrderbookWeb.OrderbookLive.Index do
      use OrderbookWeb, :live_view
      use Phoenix.LiveView
      @impl true
      def mount(_params, _session, socket) do
        if connected?(socket) do
          Orderbook.Orderbook.subscribe()
        end
        list_orderbook = list()
        list_buy =
          list_orderbook
          |>Enum.filter(fn order -> order.side == "Buy" end)
        list_sell =
          list_orderbook
          |>Enum.filter(fn order -> order.side == "Sell" end)
        {:ok, assign(socket, list_buy: list_buy, list_sell: list_sell)}
      end

      # @impl true
      # def handle_params(params, _url, socket) do
      #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
      # end

      # defp apply_action(socket, :edit, %{"id" => id}) do
      #   socket
      #   |> assign(:page_title, "Edit User")
      #   |> assign(:user, Hello.User.get_user!(id))
      # end

      # defp apply_action(socket, :new, _params) do
      #   socket
      #   |> assign(:page_title, "New User")
      #   |> assign(:user, %Hello.User{})
      # end

      # defp apply_action(socket, :index, _params) do
      #   socket
      #   |> assign(:page_title, "Listing Users")
      #   |> assign(:user, nil)
      # end

      # @impl true
      # def handle_event("delete", %{"id" => id}, socket) do
      #   user = Hello.User.get_user!(id)
      #   {:ok, _} = Hello.User.delete_user(user)

      #   {:noreply, assign(socket, :users, list_users())}
      # end

      @impl true
      def handle_info({:orderbook_fetched, new_items}, socket) do
        list_buy =
          new_items
          |>Enum.filter(fn order -> order.side == "Buy" end)
        list_sell =
          new_items
          |>Enum.filter(fn order -> order.side == "Sell" end)
        socket = socket
          |> assign(:list_buy, list_buy)
          |> assign(:list_sell, list_sell)
        {:noreply, socket}
      end

  defp list do
    Orderbook.Orderbook.get_list()
  end
end
