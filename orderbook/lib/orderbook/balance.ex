defmodule Orderbook.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "balances" do
    field :amount, :float
    field :currency, :string
    field :deposited, :float
    field :withdrawn, :float

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:currency, :amount, :deposited, :withdrawn])
    |> validate_required([:currency, :amount, :deposited, :withdrawn])
  end
end
