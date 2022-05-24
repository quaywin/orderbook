defmodule Orderbook.Orderbook do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orderbooks" do
    field :id, :integer
    field :price, :float
    field :side, :string
    field :size, :float
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(orderbook, attrs) do
    orderbook
    |> cast(attrs, [:id, :symbol, :side, :size, :price])
    |> validate_required([:id, :symbol, :side, :size, :price])
  end
end
