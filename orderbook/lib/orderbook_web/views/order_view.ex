defmodule OrderbookWeb.OrderView do
  use OrderbookWeb, :view

  def render("create.json", %{result: result}) do
    {:ok, map } = Jason.decode(result)
    %{result: map}
  end

  def render("update.json", %{result: result}) do
    {:ok, map } = Jason.decode(result)
    %{result: map}
  end

  def render("delete.json", %{result: result}) do
    {:ok, map } = Jason.decode(result)
    %{result: map}
  end
end
