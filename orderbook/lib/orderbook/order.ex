defmodule Orderbook.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :order_id, :string
    field :order_qty, :float
    field :order_type, :string
    field :price, :float
    field :side, :string
    field :symbol, :string
    field :currency, :string
    field :status, :boolean

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:id, :symbol, :side, :orderQty, :orderType, :currency, :price, :status])
    |> validate_required([:id, :symbol, :side, :orderQty, :orderType, :currency, :price, :status])
  end
end
