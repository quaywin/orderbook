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
      |> put_status(response.status)
      |> render("create.json", result: response.body)
  end

  def update(conn, body) do
    request = Map.filter(%{
      :orderID => body["id"],
      :price => body["price"],
      :orderQty => body["order_qty"]
    }, fn {_key, val} -> val != '' && val != nil end)
    {:ok, response} = OrderbookWeb.API.put("/order", request)

    conn
      |> put_status(response.status)
      |> render("update.json", result: response.body)
  end

  def delete(conn, body) do
    {:ok, response} = OrderbookWeb.API.delete("/order", %{
      :orderID => body["id"],
    })
    conn
      |> put_status(response.status)
      |> render("delete.json", result: response.body)
  end
end
