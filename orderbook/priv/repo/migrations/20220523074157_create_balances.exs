defmodule Orderbook.Repo.Migrations.CreateBalances do
  use Ecto.Migration

  def change do
    create table(:balances) do
      add :id, :uuid, primary_key: true, null: false
      add :currency, :string
      add :amount, :float
      add :deposited, :float
      add :withdrawn, :float

      add :account_id, references("accounts", type: :uuid)

      timestamps()
    end
  end
end
