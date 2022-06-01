defmodule OrderbookWeb.WebSocket do
  use WebSockex

  def start_link(topic, is_auth \\ false) do
    endpoint = "wss://ws.testnet.bitmex.com/realtime?subscribe=#{topic}"
    auth_query = URI.encode_query(Enum.into(Orderbook.Sign.get_auth_header(), %{}))
    url = if is_auth do
      "#{endpoint}&#{auth_query}"
    else
      endpoint
    end
    WebSockex.start(url, __MODULE__, topic)
  end

  def handle_frame({_type, msg}, state) do
    msg_decode = Jason.decode(msg)
    msg_map = elem(msg_decode, 1)
    table = msg_map["table"]
    data = msg_map["data"]
    action = msg_map["action"]
    case table do
      "orderBookL2_25" ->
        case action do
          "partial" ->
            Orderbook.Orderbook.insert(data)
          "update" ->
            Orderbook.Orderbook.update(data)
          "insert" ->
            Orderbook.Orderbook.insert(data)
          "delete" ->
            Orderbook.Orderbook.delete(data)
        end
      "order" ->
        case action do
          "partial" ->
            Orderbook.Order.insert(data)
          "update" ->
            Orderbook.Order.update(data)
          "insert" ->
            Orderbook.Order.insert(data)
        end
      "position" ->
        case action do
          "partial" ->
            Orderbook.Position.insert(data)
          "update" ->
            Orderbook.Position.update(data)
          "insert" ->
            Orderbook.Position.update(data)
        end
      "margin" ->
        case action do
          "partial" ->
            Orderbook.Balance.insert(data)
          "update" ->
            Orderbook.Balance.update(data)
          "insert" ->
            Orderbook.Balance.insert(data)
        end
      _ -> nil
    end
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end
end
