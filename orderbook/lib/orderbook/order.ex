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
    |> cast(attrs, [:id, :symbol, :side, :orderQty, :orderType, :currency, :price, :status])
    |> validate_required([:id, :symbol, :side, :orderQty, :orderType, :currency, :price, :status])
  end

  def insert(data) do
    unquote_data = Enum.map(data, fn m -> %{
      :order_id => m["orderID"],
      :order_qty => m["orderQty"],
      :order_type => m["ordType"],
      :price => elem(Float.parse(to_string(m["price"])),0),
      :symbol => m["symbol"],
      :side => m["side"],
      :currency => m["currency"],
      :status => m["ordStatus"]
      }
    end)
    insert_data = Enum.map(unquote_data, fn m -> Map.to_list(m) end)
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
