defmodule Orderbook.Position do
  use Ecto.Schema
  import Ecto.Changeset

  schema "positions" do
    field :entry_price, :string
    field :liquid_price, :string
    field :margin, :string
    field :mark_price, :string
    field :size, :string
    field :symbol, :string
    field :unrealised_roe_percent, :string
    field :value, :string
    field :size_currency, :string
    field :value_currency, :string
    field :is_open, :boolean

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [:symbol, :size, :value, :entry_price, :mark_price, :liquid_price, :margin, :unrealised_roe_percent])
    |> validate_required([:symbol, :size, :value, :entry_price, :mark_price, :liquid_price, :margin, :unrealised_roe_percent])
  end

  def insert(data) do
    insert_data = Enum.map(data, fn position -> [
        symbol: position["symbol"],
        size_currency: position["underlying"],
        value_currency: position["quoteCurrency"],
        entry_price: to_string(position["avgEntryPrice"]),
        liquid_price: to_string(position["liquidationPrice"]),
        mark_price: to_string(position["markPrice"]),
        size: to_string(position["homeNotional"]),
        value: to_string(position["foreignNotional"]),
        unrealised_roe_percent: to_string(position["unrealisedRoePcnt"]),
        is_open: position["isOpen"]
      ]
    end)
    Orderbook.Repo.insert_all(Orderbook.Position, insert_data)
    get_list()
      |> broadcast(:position_fetched)
  end

  def update(data) do
    data
    |> Enum.map(fn position ->
      unquote_data = [
        liquid_price: to_string(position["liquidationPrice"]),
        mark_price: to_string(position["markPrice"]),
        size: to_string(position["homeNotional"]),
        value: to_string(position["foreignNotional"]),
        unrealised_roe_percent: to_string(position["unrealisedRoePcnt"])
      ]

      unquote_data = unquote_data ++ if position["quoteCurrency"] do
        [entry_price: position["quoteCurrency"]]
      else
        []
      end

      unquote_data = unquote_data ++ if position["avgEntryPrice"] do
        [entry_price: to_string(position["avgEntryPrice"])]
      else
        []
      end
      unquote_data = unquote_data ++ if position["isOpen"] do
        [is_open: position["isOpen"]]
      else
        []
      end
      update_position = Orderbook.Repo.get_by(Orderbook.Position, symbol: position["symbol"])
      Ecto.Changeset.change(update_position, unquote_data)
        |> Orderbook.Repo.update()
    end)
    get_list()
      |> broadcast(:position_fetched)
  end

  def init(data) do
    insert_data = Enum.map(data, fn position -> [
        symbol: position["symbol"],
        size_currency: position["underlying"],
        is_open: false,
      ]
    end)
    Orderbook.Repo.insert_all(Orderbook.Position, insert_data)
  end

  def get_list() do
    Orderbook.Repo.all(Orderbook.Position)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Orderbook.PubSub, "positions")
  end

  defp broadcast({:error, _reason} = error, _event) do
    error
  end

  defp broadcast(positions, event) do
    Phoenix.PubSub.broadcast(Orderbook.PubSub, "positions", {event, positions})
    {:ok, positions}
  end
end
