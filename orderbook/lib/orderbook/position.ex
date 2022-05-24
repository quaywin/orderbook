defmodule Orderbook.Position do
  use Ecto.Schema
  import Ecto.Changeset

  schema "positions" do
    field :entry_price, :float
    field :liquid_price, :float
    field :margin, :float
    field :mark_price, :float
    field :realised_pnl, :float
    field :size, :float
    field :symbol, :string
    field :unrealised_pnl, :float
    field :unrealised_roe_percent, :float
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [:symbol, :size, :value, :entryPrice, :markPrice, :liquidPrice, :margin, :unrealisedPnl, :unrealisedRoePercent, :realisedPnl])
    |> validate_required([:symbol, :size, :value, :entryPrice, :markPrice, :liquidPrice, :margin, :unrealisedPnl, :unrealisedRoePercent, :realisedPnl])
  end
end
