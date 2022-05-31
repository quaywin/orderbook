defmodule Orderbook.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :order_id, :string
    field :order_qty, :integer
    field :order_type, :string
    field :price, :float
    field :side, :string
    field :symbol, :string
    field :currency, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:symbol, :side, :order_qty, :order_type, :currency, :price, :status])
    |> validate_required([:symbol, :side, :order_qty, :order_type, :currency, :price, :status])
  end

  def insert(data) do
    insert_data = Enum.map(data, fn order -> [
      order_id: order["orderID"],
      order_qty: order["orderQty"],
      order_type: order["ordType"],
      price: elem(Float.parse(to_string(order["price"])),0),
      symbol: order["symbol"],
      side: order["side"],
      currency: order["currency"],
      status: order["ordStatus"]
    ]
    end)
    Orderbook.Repo.insert_all(Orderbook.Order, insert_data)
  end

  def update(data) do
    Enum.map(data, fn order ->
      id = order["orderID"]
      unquote_data = cond do
        order["price"] -> [price: elem(Float.parse(to_string(order["price"])),0)]
        order["orderQty"] -> [order_qty: order["orderQty"]]
        order["ordStatus"] -> [status: order["ordStatus"]]
      end
      # insert_data = Enum.map(unquote_data, fn m -> Map.to_list(m) end)
      updated_order = Orderbook.Repo.get_by(Orderbook.Order, order_id: id)
      Ecto.Changeset.change(updated_order, unquote_data)
        |> Orderbook.Repo.update()
    end)

  end
end
