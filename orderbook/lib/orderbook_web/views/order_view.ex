defmodule OrderbookWeb.OrderView do
  use OrderbookWeb, :view

  def render("create.json", %{result: result}) do
    %{result: result}
  end
end
