defmodule Orderbook.Repo.Migrations.CreateOrderbooks do
  use Ecto.Migration

  def change do
    create table(:orderbooks) do
      add :id, :integer
      add :symbol, :string
      add :side, :string
      add :size, :float
      add :price, :float

      timestamps()
    end
  end
end
