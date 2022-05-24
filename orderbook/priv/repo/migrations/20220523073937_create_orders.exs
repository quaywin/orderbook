defmodule Orderbook.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :id, :string
      add :symbol, :string
      add :side, :string
      add :order_qty, :float
      add :order_type, :string
      add :price, :float
      add :currency, :string
      add :status, :boolean

      timestamps()
    end
  end
end
