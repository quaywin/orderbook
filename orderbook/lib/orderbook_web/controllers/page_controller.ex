defmodule OrderbookWeb.PageController do
  use OrderbookWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
