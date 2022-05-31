defmodule Orderbook.Orderbook do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orderbooks" do
    field :price, :float
    field :side, :string
    field :size, :integer
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(orderbook, attrs) do
    orderbook
    |> cast(attrs, [:id, :symbol, :side, :size, :price])
    |> validate_required([:id, :symbol, :side, :size, :price])
  end

  def insert(data) do
    insert_data = Enum.map(data, fn order -> [
        id: order["id"],
        price: elem(Float.parse(to_string(order["price"])),0),
        side: order["side"],
        size: order["size"],
        symbol: order["symbol"]
      ]
    end)
    Orderbook.Repo.insert_all(Orderbook.Orderbook, insert_data)
  end

  def update(data) do
    Enum.map(data, fn order ->
      id = order["id"]
      unquote_data = [
        side: order["side"],
        size: order["size"],
        symbol: order["symbol"]
      ]
      unquote_data = unquote_data ++ if order["price"] do
        [price: elem(Float.parse(to_string(order["price"])),0)]
      else
        []
      end

      # insert_data = Enum.map(unquote_data, fn m -> Map.to_list(m) end)
      updated_order = Orderbook.Repo.get(Orderbook.Orderbook, id)
      Ecto.Changeset.change(updated_order, unquote_data)
        |> Orderbook.Repo.update()
    end)
  end

  def delete(data) do
    Enum.map(data, fn order ->
      id = order["id"]
      # insert_data = Enum.map(unquote_data, fn m -> Map.to_list(m) end)
      deleted_order = Orderbook.Repo.get(Orderbook.Orderbook, id)
      Orderbook.Repo.delete(deleted_order)
    end)
  end

end
