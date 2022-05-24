defmodule Orderbook.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def change do
    create table(:positions) do
      add :symbol, :string
      add :size, :float
      add :value, :float
      add :entryPrice, :float
      add :markPrice, :float
      add :liquidPrice, :float
      add :margin, :float
      add :unrealisedPnl, :float
      add :unrealisedRoePercent, :float
      add :realisedPnl, :float

      timestamps()
    end
  end
end
