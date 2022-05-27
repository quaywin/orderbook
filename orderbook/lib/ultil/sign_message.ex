defmodule Orderbook.Sign do
  def sign_message(verb, url, expires, data \\ "") do
    secret = Application.get_env(:orderbook, OrderbookWeb.WebSocket)[:api_key_secret]
    :crypto.mac(:hmac, :sha256, secret, "#{verb}#{url}#{expires}#{data}")
      |> Base.encode16(case: :lower)
  end

  def get_auth_header(verb \\ "GET", url \\ "/realtime", data \\ "") do
    api_key = Application.get_env(:orderbook, OrderbookWeb.WebSocket)[:api_key_id]
    expires = DateTime.utc_now() |> DateTime.to_unix(:millisecond) |> Integer.to_string()
    [
      {"api-expires", expires},
      {"api-key", api_key},
      {"api-signature", sign_message(verb, url, expires, data)}
    ]
  end
end
