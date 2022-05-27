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

  def insert_list(data) do
    unquote_data = Enum.map(data, fn m -> %{
      :id => m["id"],
      :price => elem(Float.parse(to_string(m["price"])),0),
      :side => m["side"],
      :size => m["size"],
      :symbol => m["symbol"]
      }
    end)
    old_data = Orderbook.Repo.all(Orderbook.Orderbook)
    Enum.map(old_data, fn x -> Orderbook.Repo.delete(x) end)
    insert_data = Enum.map(unquote_data, fn m -> Map.to_list(m) end)
    Orderbook.Repo.insert_all(Orderbook.Orderbook, insert_data)
  end
end
