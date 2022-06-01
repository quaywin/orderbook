defmodule Orderbook.Orderbook do
  use Ecto.Schema
  import Ecto.Changeset
  # import Ecto.Query, only: [from: 2]

  schema "orderbooks" do
    field :price, :float
    field :side, :string
    field :size, :integer
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(orderbook, attrs) do
    orderbook
    |> cast(attrs, [:id, :symbol, :side, :size, :price])
    |> validate_required([:id, :symbol, :side, :size, :price])
  end

  def insert(data) do
    insert_data = Enum.map(data, fn order -> [
        id: order["id"],
        price: elem(Float.parse(to_string(order["price"])),0),
        side: order["side"],
        size: order["size"],
        symbol: order["symbol"]
      ]
    end)
    Orderbook.Repo.insert_all(Orderbook.Orderbook, insert_data)
    orderbooks = get_list()
    broadcast(orderbooks, :orderbook_fetched)
  end

  def update(data) do
    Enum.map(data, fn order ->
      id = order["id"]
      unquote_data = [
        side: order["side"],
        size: order["size"],
        symbol: order["symbol"]
      ]
      unquote_data = unquote_data ++ if order["price"] do
        [price: elem(Float.parse(to_string(order["price"])),0)]
      else
        []
      end

      # insert_data = Enum.map(unquote_data, fn m -> Map.to_list(m) end)
      updated_order = Orderbook.Repo.get(Orderbook.Orderbook, id)
      Ecto.Changeset.change(updated_order, unquote_data)
        |> Orderbook.Repo.update()
      orderbooks = get_list()
      broadcast(orderbooks, :orderbook_fetched)
    end)
  end

  def delete(data) do
    Enum.map(data, fn order ->
      id = order["id"]
      # insert_data = Enum.map(unquote_data, fn m -> Map.to_list(m) end)
      deleted_order = Orderbook.Repo.get(Orderbook.Orderbook, id)
      Orderbook.Repo.delete(deleted_order)
      orderbooks = get_list()
      broadcast(orderbooks, :orderbook_fetched)
    end)
  end

  # def list_buy() do
  #   Orderbook.Repo.all(from Orderbook.Orderbook, where: [side: "Buy"], select: [:id, :price, :side, :size, :symbol])
  # end

  # def list_sell() do
  #   Orderbook.Repo.all(from Orderbook.Orderbook, where: [side: "Sell"], select: [:id, :price, :side, :size, :symbol])
  # end

  def get_list() do
    Orderbook.Repo.all(Orderbook.Orderbook)
      |>Enum.sort_by(&(&1.price), :desc)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Orderbook.PubSub, "orderbooks")
  end

  defp broadcast({:error, _reason} = error, _event) do
    error
  end

  defp broadcast(orderbooks, event) do
    Phoenix.PubSub.broadcast(Orderbook.PubSub, "orderbooks", {event, orderbooks})
    {:ok, orderbooks}
  end

end
