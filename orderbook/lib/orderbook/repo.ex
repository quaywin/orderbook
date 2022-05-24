defmodule Orderbook.Repo do
  use Ecto.Repo,
    otp_app: :orderbook,
    adapter: Etso.Adapter
end
