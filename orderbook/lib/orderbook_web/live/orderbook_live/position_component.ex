defmodule OrderbookWeb.OrderbookLive.PositionComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    if connected?(socket) do
      Orderbook.Position.subscribe()
    end

    positions =
      Orderbook.Position.get_list()
      |> get_list()
    {:ok, assign(socket, positions: positions), temporary_assigns: [positions: []]}
  end

  def update(assigns, socket) do
    socket = if assigns[:positions] do
        assign(socket, :positions, get_list(assigns[:positions]))
    else
      socket
    end
    {:ok, socket}
  end

  defp get_list(positions) do
    positions
      |> Enum.filter(fn position -> position.is_open == true end)
      |> Enum.map(fn position ->
        style = case elem(Float.parse(to_string(position.size)),0) do
          size when size > 0 -> "text-green-600"
          size when size < 0 -> "text-red-600"
        end
        roe = elem(Float.parse(to_string(position.unrealised_roe_percent)),0)*100
        Map.put(position, :style, style)
          |> Map.put(:roe, Float.round(roe, 2))
      end)

  end
end
