defmodule OrderbookWeb.OrderController do
  use OrderbookWeb, :controller

  def create(conn, body) do
    {:ok, response} = OrderbookWeb.API.post("/order", %{
      :symbol => body["symbol"] || "XBTUSD",
      :side => body["side"] || "Buy",
      :ordType => body["order_type"] || "Limit",
      :price => body["price"],
      :orderQty => body["order_qty"]
    })
    conn
      |> put_status(200)
      |> render("create.json", result: response.status)
  end

  # def get_all do
  #   orders = Bitmex.
  # end
end
