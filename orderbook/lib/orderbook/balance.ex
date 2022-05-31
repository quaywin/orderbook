defmodule Orderbook.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "balances" do
    field :currency, :string
    field :wallet, :integer
    field :margin, :integer
    field :available, :integer
    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:currency, :wallet, :margin, :available])
    |> validate_required([:currency, :wallet, :margin, :available])
  end

  def insert(data) do
    insert_data = Enum.map(data, fn balance -> [
      currency: balance["currency"],
      wallet: balance["walletBalance"],
      margin: balance["marginBalance"],
      available: balance["availableMargin"]
    ]
    end)
    Orderbook.Repo.insert_all(Orderbook.Balance, insert_data)
  end

  def update(data) do
    Enum.map(data, fn balance ->
      unquote_data = [
        margin: balance["marginBalance"],
        available: balance["availableMargin"]
      ]

      unquote_data = unquote_data ++ if balance["walletBalance"] do
        [wallet: balance["walletBalance"]]
      else
        []
      end

      # insert_data = Enum.map(unquote_data, fn m -> Map.to_list(m) end)
      updated_balance = Orderbook.Repo.get_by(Orderbook.Balance, currency: balance["currency"])
      Ecto.Changeset.change(updated_balance, unquote_data)
        |> Orderbook.Repo.update()
    end)

  end
end
