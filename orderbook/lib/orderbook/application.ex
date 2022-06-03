defmodule Orderbook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Orderbook.Repo,
      # Start the Telemetry supervisor
      OrderbookWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Orderbook.PubSub},
      # Start the Endpoint (http/https)
      OrderbookWeb.Endpoint,
      %{
        id: :orderbook,
        start: {OrderbookWeb.WebSocket, :start_link, ["orderBookL2_25:XBTUSDT"]}
      },
      %{
        id: :order,
        start: {OrderbookWeb.WebSocket, :start_link, ["order", true]}
      },
      %{
        id: :position,
        start: {OrderbookWeb.WebSocket, :start_link, ["position", true]}
      },
      %{
        id: :balance,
        start: {OrderbookWeb.WebSocket, :start_link, ["margin", true]}
      },
      # {OrderbookWeb.WebSocket, ["order", true], id: :order}
      # Start a worker by calling: Orderbook.Worker.start_link(arg)
      # {Orderbook.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Orderbook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OrderbookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
