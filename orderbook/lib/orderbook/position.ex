defmodule Orderbook.Position do
  use Ecto.Schema
  import Ecto.Changeset

  schema "positions" do
    field :entry_price, :float
    field :liquid_price, :float
    field :margin, :float
    field :mark_price, :float
    field :size, :integer
    field :symbol, :string
    field :unrealised_roe_percent, :float
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [:symbol, :size, :value, :entry_price, :mark_price, :liquid_price, :margin, :unrealised_roe_percent])
    |> validate_required([:symbol, :size, :value, :entry_price, :mark_price, :liquid_price, :margin, :unrealised_roe_percent])
  end

  def insert(data) do
    data = Enum.filter(data, fn position -> position["isOpen"] == true end )
    insert_data = Enum.map(data, fn position -> [
        symbol: position["symbol"],
        entry_price: elem(Float.parse(to_string(position["avgEntryPrice"])),0),
        liquid_price: elem(Float.parse(to_string(position["liquidationPrice"])),0),
        mark_price: elem(Float.parse(to_string(position["markPrice"])),0),
        size: position["currentQty"],
        value: position["homeNotional"],
        unrealised_roe_percent: position["unrealisedRoePcnt"]
      ]
    end)
    Orderbook.Repo.insert_all(Orderbook.Position, insert_data)
  end

  def update(data) do
    Enum.map(data, fn position ->
      unquote_data = [
        liquid_price: elem(Float.parse(to_string(position["liquidationPrice"])),0),
        mark_price: elem(Float.parse(to_string(position["markPrice"])),0),
        size: position["currentQty"],
        value: position["homeNotional"],
        unrealised_roe_percent: position["unrealisedRoePcnt"]
      ]
      unquote_data = unquote_data ++ if position["avgEntryPrice"] do
        [entry_price: position["avgEntryPrice"]]
      else
        []
      end
      case position["isOpen"] do
        true ->
          Orderbook.Repo.insert(%Orderbook.Position{
            symbol: position["symbol"],
            entry_price: elem(Float.parse(to_string(position["avgEntryPrice"])),0),
            liquid_price: elem(Float.parse(to_string(position["liquidationPrice"])),0),
            mark_price: elem(Float.parse(to_string(position["markPrice"])),0),
            size: position["currentQty"],
            value: position["homeNotional"],
            unrealised_roe_percent: position["unrealisedRoePcnt"]
          })
        false ->
          delete_position = Orderbook.Repo.get_by(Orderbook.Position, symbol: position["symbol"])
          Orderbook.Repo.delete(delete_position)
        _ ->
          update_position = Orderbook.Repo.get_by(Orderbook.Position, symbol: position["symbol"])
          Ecto.Changeset.change(update_position, unquote_data)
            |> Orderbook.Repo.update()
      end
    end)
  end
end
